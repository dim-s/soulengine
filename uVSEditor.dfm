object phpVSEditor: TphpVSEditor
  OldCreateOrder = False
  Height = 257
  Width = 332
  object _VSEditor: TPHPLibrary
    Functions = <
      item
        FunctionName = 'vs_inspector_add'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end
          item
            Name = 'Param3'
            ParamType = tpUnknown
          end
          item
            Name = 'Param4'
            ParamType = tpString
          end>
        OnExecute = _VSEditorFunctions0Execute
      end
      item
        FunctionName = 'vs_inspector_addfirst'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end
          item
            Name = 'Param3'
            ParamType = tpUnknown
          end
          item
            Name = 'Param4'
            ParamType = tpUnknown
          end>
        OnExecute = _VSEditorFunctions1Execute
      end
      item
        FunctionName = 'vs_inspector_additem'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end
          item
            Name = 'Param3'
            ParamType = tpUnknown
          end
          item
            Name = 'Param4'
            ParamType = tpUnknown
          end>
        OnExecute = _VSEditorFunctions2Execute
      end
      item
        FunctionName = 'vs_inspector_unfocus'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _VSEditorFunctions3Execute
      end
      item
        FunctionName = 'vs_inspector_selectedindex'
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
        OnExecute = _VSEditorFunctions4Execute
      end>
    Left = 24
    Top = 24
  end
  object _VSItems: TPHPLibrary
    Functions = <
      item
        FunctionName = 'vs_item_font'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end
          item
            Name = 'Param3'
            ParamType = tpUnknown
          end
          item
            Name = 'ValueFont'
            ParamType = tpUnknown
          end>
        OnExecute = _VSItemsFunctions0Execute
      end
      item
        FunctionName = 'vs_item_add'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end
          item
            Name = 'Param2'
            ParamType = tpUnknown
          end
          item
            Name = 'Param3'
            ParamType = tpUnknown
          end>
        OnExecute = _VSItemsFunctions1Execute
      end
      item
        FunctionName = 'vs_item_lines'
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
        OnExecute = _VSItemsFunctions2Execute
      end>
    Left = 88
    Top = 24
  end
end
