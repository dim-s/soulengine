object phpHTMLView: TphpHTMLView
  OldCreateOrder = False
  Left = 245
  Top = 111
  Height = 269
  Width = 394
  object _HTMLView: TPHPLibrary
    Functions = <
      item
        FunctionName = 'htmlview_reload'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions0Execute
      end
      item
        FunctionName = 'htmlview_clear'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions1Execute
      end
      item
        FunctionName = 'htmlview_goback'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions2Execute
      end
      item
        FunctionName = 'htmlview_goforward'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions3Execute
      end
      item
        FunctionName = 'htmlview_navigate'
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
        OnExecute = _HTMLViewFunctions4Execute
      end
      item
        FunctionName = 'htmlview_title'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions5Execute
      end
      item
        FunctionName = 'htmlview_url'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
      end
      item
        FunctionName = 'htmlview_processing'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpUnknown
          end>
        OnExecute = _HTMLViewFunctions7Execute
      end
      item
        FunctionName = 'htmlview_text'
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
        OnExecute = _HTMLViewFunctions8Execute
      end>
    Left = 88
    Top = 112
  end
end
