unit dwsHashtables;

interface

uses SysUtils;

type
  ValueType = ansistring;

  THashItem = class
    Twin: THashItem;
    Value: ValueType;
    function HashCode: integer; virtual; abstract;
    function Equals(Item: THashItem): boolean; reintroduce; virtual; abstract;
  end;

  PHashItems = ^THashItems;
  THashItems = array[0..MaxInt div Sizeof(THashItem) - 1] of THashItem;

  THashTable = class
  public
    FCapacity: integer;
    FSize: integer;
    FThreshold: integer;
    FLoadFactor: integer; // In percent
    FItems: PHashItems;
    procedure Rehash(NewCapacity: integer);
  protected
    function InternalGet(Item: THashItem): ValueType;
    function InternalFind(Item: THashItem): THashItem;

    procedure InternalPut(Item: THashItem);
    function InternalHasKey(Item: THashItem): boolean;
    function InternalRemoveKey(Item: THashItem): ValueType;
  public
    constructor Create(InitCapacity: integer = 256; LoadFactor: integer = 75);
    destructor Destroy; override;
    procedure Clear;
    property Capacity: integer read FCapacity;
    property Size: integer read FSize;
  end;

  TStringHashItem = class(THashItem)
  private
    Key: string;

  public
    function HashCode: integer; override;
    function Equals(Item: THashItem): boolean; override;
  end;

  TStringHashTable = class(THashTable)
  private
    FTestItem: TStringHashItem;
  public
    constructor Create(InitCapacity: integer = 256; LoadFactor: integer = 75);
    destructor Destroy; override;
    function Get(const Key: string): ValueType;
    procedure SetValue(const Key: string; Value: ValueType);
    procedure Put(const Key: string; Value: ValueType);
    function HasKey(const Key: string): boolean;
    function RemoveKey(const Key: string): ValueType;
  end;

  TIntegerHashItem = class(THashItem)
  private
    Key: integer;

  public
    function HashCode: integer; override;
    function Equals(Item: THashItem): boolean; override;
  end;

  TIntegerHashTable = class(THashTable)
  private
    FTestItem: TIntegerHashItem;
  public
    constructor Create(InitCapacity: integer = 256; LoadFactor: integer = 75);
    destructor Destroy; override;
    function Get(const Key: integer): ValueType;
    procedure Put(const Key: integer; Value: ValueType);
    function HasKey(const Key: integer): boolean;
    function RemoveKey(const Key: integer): ValueType;
  end;

implementation

var
  HashTable: array[#0..#255] of byte;
  InsensitiveHashTable: array[#0..#255] of byte;

procedure InitTables;
var
  I, K: char;
  Temp: integer;
begin
  for I := #0 to #255 do
  begin
    HashTable[I] := Ord(I);
    InsensitiveHashTable[I] := Ord(AnsiUpperCase(string(I))[1]);
  end;
  RandSeed := 111;
  for I := #1 to #255 do
  begin
    repeat
      K := char(Random(255));
    until K <> #0;
    Temp := HashTable[I];
    HashTable[I] := HashTable[K];
    HashTable[K] := Temp;
  end;
end;

{ THashTable }

constructor THashTable.Create(InitCapacity, LoadFactor: integer);
begin
  if (InitCapacity < 1) or (InitCapacity >= MaxInt div Sizeof(integer)) then
    raise Exception.CreateFmt('Invalid InitCapacity: %d', [InitCapacity]);
  if (LoadFactor < 0) or (LoadFactor > 100) then
    raise Exception.CreateFmt('Invalid LoadFactor: %d', [LoadFactor]);
  FLoadFactor := LoadFactor;
  Rehash(InitCapacity);
end;

destructor THashTable.Destroy;
begin
  Clear;
  FreeMem(FItems);
  inherited;
end;

procedure THashTable.Clear;
var
  x: integer;
  oldItem, hashItem: THashItem;
begin
  for x := 0 to FCapacity - 1 do
  begin
    hashItem := FItems[x];
    while Assigned(hashItem) do
    begin
      oldItem := hashItem;
      hashItem := hashItem.Twin;
      oldItem.Free;
    end;
    FItems[x] := nil;
  end;
end;

function THashTable.InternalFind(Item: THashItem): THashItem;
var
  hashItem: THashItem;
begin
  hashItem := FItems[Item.HashCode mod FCapacity];

  while hashItem <> nil do
  begin
    if hashItem.Equals(Item) then
    begin
      Result := hashItem;
      Exit;
    end;
    hashItem := hashItem.Twin;
  end;

  Result := hashItem;
end;

function THashTable.InternalGet(Item: THashItem): ValueType;
var
  hashItem: THashItem;
begin
  hashItem := FItems[Item.HashCode mod FCapacity];

  while hashItem <> nil do
  begin
    if hashItem.Equals(Item) then
    begin
      Result := hashItem.Value;
      Exit;
    end;
    hashItem := hashItem.Twin;
  end;

  Result := '';
end;

function THashTable.InternalHasKey(Item: THashItem): boolean;
var
  hashItem: THashItem;
begin
  Result := False;

  hashItem := FItems[Item.HashCode mod FCapacity];

  while hashItem <> nil do
  begin
    if hashItem.Equals(Item) then
    begin
      Result := True;
      Exit;
    end;
    hashItem := hashItem.Twin;
  end;
end;

procedure THashTable.InternalPut(Item: THashItem);
var
  hash: integer;
begin
  Inc(FSize);

  if FSize > FThreshold then
    // Double the size of the hashtable
    Rehash(FCapacity * 2);

  // Find item with same hash-key
  // Insert new item to the existing (if any)
  hash := Item.HashCode mod FCapacity;
  Item.Twin := FItems[hash];
  FItems[hash] := Item;
end;

function THashTable.InternalRemoveKey(Item: THashItem): ValueType;
var
  hashItem, lastItem: THashItem;
  hash: integer;
begin
  hash := Item.HashCode mod FCapacity;
  hashItem := FItems[hash];
  lastItem := nil;

  while hashItem <> nil do
  begin
    if hashItem.Equals(Item) then
    begin
      // Remove item from pointer chain
      if lastItem = nil then
        FItems[hash] := hashItem.Twin
      else
        lastItem.Twin := hashItem.Twin;

      // Dispose item
      Result := hashItem.Value;
      hashItem.Free;
      Dec(FSize);
      Exit;
    end;
    lastItem := hashItem;
    hashItem := hashItem.Twin;
  end;
  Result := '';
end;

procedure THashTable.Rehash(NewCapacity: integer);
var
  x, hash: integer;
  newItems: PHashItems;
  itm, Twin: THashItem;
begin
  // Enlarge the size of the hashtable
  GetMem(newItems, Sizeof(THashItem) * NewCapacity);

  // Clear new space
  for x := 0 to NewCapacity - 1 do
    newItems[x] := nil;

  // Transfer items to the new hashtable
  for x := 0 to FCapacity - 1 do
  begin
    itm := FItems[x];
    while itm <> nil do
    begin
      Twin := itm.Twin;
      hash := itm.HashCode mod NewCapacity;
      itm.Twin := newItems[hash];
      newItems[hash] := itm;
      itm := Twin;
    end;
  end;

  FreeMem(FItems);

  FItems := newItems;
  FThreshold := (NewCapacity div 100) * FLoadFactor;

  FCapacity := NewCapacity;
end;

{ TStringHashItem }

function TStringHashItem.Equals(Item: THashItem): boolean;
begin
  Result := SameText(Key, TStringHashItem(Item).Key);
end;

function TStringHashItem.HashCode: integer;
var
  I: integer;
begin
  Result := 0;
  for i := 1 to length(Key) do
  begin
    Result := (Result shr 4) xor
      (((Result xor InsensitiveHashTable[Key[I]]) and $F) * $80);
    Result := (Result shr 4) xor
      (((Result xor (Ord(InsensitiveHashTable[Key[I]]) shr 4)) and $F) * $80);
    if I = 3 then
      break;
  end;
  if Result = 0 then
    Result := Length(Key) mod 8 + 1;
end;

{ TStringHashTable }

constructor TStringHashTable.Create(InitCapacity, LoadFactor: integer);
begin
  inherited;
  FTestItem := TStringHashItem.Create;
end;

destructor TStringHashTable.Destroy;
begin
  inherited;
  FTestItem.Free;
end;

function TStringHashTable.Get(const Key: string): ValueType;
begin
  FTestItem.Key := Key;
  Result := InternalGet(FTestItem);
end;

function TStringHashTable.HasKey(const Key: string): boolean;
begin
  FTestItem.Key := Key;
  Result := InternalHasKey(FTestItem);
end;

procedure TStringHashTable.Put(const Key: string; Value: ValueType);
var
  item: TStringHashItem;
begin
  item := TStringHashItem.Create;
  item.Key := Key;
  item.Value := Value;
  InternalPut(item);
end;

function TStringHashTable.RemoveKey(const Key: string): ValueType;
begin
  FTestItem.Key := Key;
  Result := InternalRemoveKey(FTestItem);
end;

procedure TStringHashTable.SetValue(const Key: string; Value: ValueType);
var
  item, ret: TStringHashItem;
begin
  item := TStringHashItem.Create;
  item.Key := Key;

  ret := TStringHashItem(InternalFind(item));
  if ret <> nil then
  begin
    ret.Value := Value;
    item.Free;
  end
  else
  begin
    item.Value := Value;
    InternalPut(item);
  end;
end;

{ TIntegerHashItem }

function TIntegerHashItem.Equals(Item: THashItem): boolean;
begin
  Result := Key = TIntegerHashItem(Item).Key;
end;

function TIntegerHashItem.HashCode: integer;
begin
  Result := Key;
end;

{ TIntegerHashTable }

constructor TIntegerHashTable.Create(InitCapacity, LoadFactor: integer);
begin
  inherited;
  FTestItem := TIntegerHashItem.Create;
end;

destructor TIntegerHashTable.Destroy;
begin
  FTestItem.Free;
  inherited;
end;

function TIntegerHashTable.Get(const Key: integer): ValueType;
begin
  FTestItem.Key := Key;
  Result := InternalGet(FTestItem);
end;

function TIntegerHashTable.HasKey(const Key: integer): boolean;
begin
  FTestItem.Key := Key;
  Result := InternalHasKey(FTestItem);
end;

procedure TIntegerHashTable.Put(const Key: integer; Value: ValueType);
var
  item: TIntegerHashItem;
begin
  item := TIntegerHashItem.Create;
  item.Key := Key;
  item.Value := Value;
  InternalPut(item);
end;

function TIntegerHashTable.RemoveKey(const Key: integer): ValueType;
begin
  FTestItem.Key := Key;
  Result := InternalRemoveKey(FTestItem);
end;

initialization
  InitTables
end.
