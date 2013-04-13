object PHPCatButtons: TPHPCatButtons
  OldCreateOrder = False
  Height = 255
  Width = 364
  object _ButtonCatigories: TPHPLibrary
    Functions = <
      item
        FunctionName = 'btncatigories_add'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions0Execute
      end
      item
        FunctionName = 'btncatigories_insert'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions1Execute
      end
      item
        FunctionName = 'categorybtns_categories'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions2Execute
      end
      item
        FunctionName = 'categorybtns_images'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions3Execute
      end
      item
        FunctionName = 'categorybtns_selected'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions4Execute
      end
      item
        FunctionName = 'categorybtns_unselect'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions5Execute
      end
      item
        FunctionName = 'btncatigories_addbutton'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _ButtonCatigoriesFunctions6Execute
      end>
    Left = 88
    Top = 72
  end
end
