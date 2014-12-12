classdef scalebar < handle
%===============================================================================
% SCALEBAR 
% Creates an integrated XY scalebar object on a data plot.
% 
% scalebar()                 =>  Creates scalebar on the current axis.
% scalebar(haxis)            =>  Creates scalebar on the axis with handle haxis.
% scalebar(haxis,'Property',value) => Creates a scalebar on the designated axis
%                                     with properties defined the by the 
%                                     property-value pairing.
%
% Properties are as follows (defaults are enclosed in brackets):
%
%   
%
%   'XLen' or 'YLen'        Length of X or Y scalebars.  Defaults to 10% of 
%                           axis length.
%
%   'XString' or 'YString'  String to place alongside each scalebar.  Default is
%                           the concatenated length and units.
%
%   'XUnits' or 'YUnits'    Units to include in the string label.
%
%   'Location'              'UR' ['LR'] 'LL' 'UL'
%                           Location of scalebar. Default is lower right (LR).
%                           Can also place in upper right(UR), lower left(LL),
%                           and upper left(UL).                         
%
%   'Position'              [X Y]
%                           Position of the scale bar.  Enter a precise position
%                           in axis coordinates to override the default location
%                           and position the scalebar anywhere within plot. The
%                           position is defined as meeting point of XY 
%                           scale bars.
%
%   'Orientation'           Orientation of vertical Y bar relative to X bar.
%                           'Right' orientation indicates Y bar is at right-most
%                           end of X bar. 'Left' orientation indicates that Y 
%                           bar is at left-most end.  Default is 'right'.
%
%   'FontName'              Set font attributes for text labels.             
%   'FontSize'
%   'FontWeight'
%   'FontAngle'
%
%   'Visible'               Turn 'on' or 'off' entire scalebar object.
%
%   'Labels'                Turn 'on' or 'off' text labels.
%
%
% MJRusso 11/2014
%===============================================================================

%=============================== PROPERTIES ====================================
properties (SetAccess = private, GetAccess = public)
    
    %Component handles
    hScalebar
    hXLine
    hYLine
    hXText
    hYText
    hParent
    
    %Scalebar parameters
    XLen
    YLen
    XUnits
    YUnits
    XString
    YString
    
    %Other options
    Position
    Location
    Orientation
    Anchor
    LineWidth
    Visible
    Color 
    Labels
    FontName
    FontWeight
    FontSize
    FontAngle

end %properties, private/public


%===============================================================================
%================================= METHODS =====================================
%===============================================================================

methods

%=============================== CONSTRUCTOR ===================================
    function obj = scalebar(varargin)
        
        if nargin == 0 
            obj.hParent = gca;
        elseif ishandle(varargin{1})
            obj.hParent = varargin{1};
        else
            obj.hParent = gca;
        end
        
        %Get axis parameters
        axisXLim = get(obj.hParent,'XLim');
        axisYLim = get(obj.hParent,'YLim');
        axisXWidth = diff(axisXLim);
        axisYWidth = diff(axisYLim);
      
        %Defaults
        obj.Color = [0 0 0];
        obj.LineWidth = 1.5;
        obj.XLen = 0.1*axisXWidth; %10percent of x axis
        obj.YLen = 0.1*axisYWidth; %10percent of y axis
        obj.XString = '';
        obj.YString = '';
        obj.XUnits = '';
        obj.YUnits = '';
        obj.Orientation = 'right';
        obj.Location = 'LR'; %Lower right, default
        obj.Position = 0;
        obj.Labels = 'off'; %Text labels turned off by default unless units are
                            %defined
        obj.FontName = 'Helvetica';
        obj.FontWeight = 'normal';
        obj.FontSize = 12;
        obj.FontAngle = 'normal';
        
        font = {'FontName',obj.FontName,'FontWeight',obj.FontWeight,...
                'FontSize',obj.FontSize,'FontAngle',obj.FontAngle};
        
        %------------------ Argument Handling ---------------------
       
        for n=1:nargin
            switch varargin{n}
                case {'XLen','xlen','Xlen','xLen'}
                    obj.XLen = varargin{n+1};
                case {'YLen','ylen','Ylen','yLen'}
                    obj.YLen = varargin{n+1};
                case {'XString','xstring','Xstring','xString'}
                    obj.XString = varargin{n+1};
                case {'YString','ystring','Ystring','yString'}
                    obj.YString = varargin{n+1};
                case {'XUnits','xunits','xUnits','Xunits'}
                    obj.XUnits = varargin{n+1};
                    obj.Labels = 'on';
                case {'YUnits','yunits','yUnits','Yunits'}
                    obj.YUnits = varargin{n+1};
                    obj.Labels = 'on';
                case {'Position','position'}
                    obj.Position = varargin{n+1};
                case {'Orientation','orientation'}
                    obj.Orientation = varargin{n+1};
                case {'Location','location'}
                    obj.Location = varargin{n+1};
                case {'Labels','labels'}
                    obj.Labels = varargin{n+1};
                case {'Color','color'}
                    obj.Color = varargin{n+1};
                case {'FontName','fontname'}'
                    obj.FontName = varargin{n+1};
                case {'FontWeight','fontweight'}'
                    obj.FontWeight = varargin{n+1};
                case {'FontSize','fontsize'}'
                    obj.FontSize = varargin{n+1};
                case {'FontAngle','fontangle'}'
                    obj.FontAngle = varargin{n+1};
            end %switch
        end %for loop, args
        
        if obj.Position
            obj.Anchor = obj.Position;
        else
            switch obj.Location
                case {'LR','lr'}
                    obj.Anchor = [axisXLim(2) - 0.1*axisXWidth, ...
                                  axisYLim(1) + 0.1*axisYWidth];
                case {'UR','ur'}
                    obj.Anchor = [axisXLim(2) - 0.1*axisXWidth, ...
                                  axisYLim(2) - 0.1*axisYWidth];
                case {'UL','ul'}
                    obj.Anchor = [axisXLim(1) + 0.1*axisXLim(1), ...
                                  axisYLim(2) - 0.1*axisYWidth];
                case {'LL','ll'}
                    obj.Anchor = [axisXLim(1) + 0.1*axisXWidth, ...
                                  axisYLim(1) + 0.1*axisYWidth];
            end
        end %if pos defined
        %-----------------------------------------------------------
        
        if strcmpi(obj.Orientation,'right')
            
            XLineXValues = [obj.Anchor(1),obj.Anchor(1)-obj.XLen];
            XLineYValues = [obj.Anchor(2),obj.Anchor(2)]; 
            YLineXValues = [obj.Anchor(1),obj.Anchor(1)];
            YLineYValues = [obj.Anchor(2),obj.Anchor(2)+obj.YLen];

            XTextXValue = obj.Anchor(1)-obj.XLen;
            XTextYValue = obj.Anchor(2);
            YTextXValue = obj.Anchor(1);
            YTextYValue = obj.Anchor(2);
            
        elseif strcmpi(obj.Orientation,'left')
            
            XLineXValues = [obj.Anchor(1),obj.Anchor(1)+obj.XLen];
            XLineYValues = [obj.Anchor(2),obj.Anchor(2)]; 
            YLineXValues = [obj.Anchor(1),obj.Anchor(1)];
            YLineYValues = [obj.Anchor(2),obj.Anchor(2)+obj.YLen];

            XTextXValue = obj.Anchor(1);
            XTextYValue = obj.Anchor(2);
            YTextXValue = obj.Anchor(1);
            YTextYValue = obj.Anchor(2);
        end
        
        %Render lines and text
        obj.hXLine = line(XLineXValues,XLineYValues,'Parent',obj.hParent);
        obj.hYLine = line(YLineXValues,YLineYValues,'Parent',obj.hParent);
        
        %Render text, then adjust
        obj.XString = [num2str(obj.XLen) ' ' obj.XUnits ];
        obj.YString = [num2str(obj.YLen) ' ' obj.YUnits ];
        obj.hXText = text(XTextXValue,XTextYValue,obj.XString,'Parent',obj.hParent);
        obj.hYText = text(YTextXValue,YTextYValue,obj.YString,'Parent',obj.hParent);

        set(obj.hYText,'Rotation',90,font{:},'Color',obj.Color);
        set(obj.hXText,font{:},'Color',obj.Color);
        %Necessary to adjust YText according to hits horizontal extent (which is
        %in different units.
        prevUnits = get(obj.hXText,'Units');    
        set([obj.hXText,obj.hYText],'Units','normalized');   
                                     
        XTextPos = get(obj.hXText,'Position');
        YTextPos = get(obj.hYText,'Position');
        XTextExt = get(obj.hXText,'Extent');
        YTextExt = get(obj.hXText,'Extent');
        
        
        if strcmpi(obj.Orientation,'right')
            XTextPos(2) = XTextPos(2)-XTextExt(4);
            YTextPos(1) = YTextPos(1)+YTextExt(4);
        else strcmpi(obj.Orientation,'left')
            XTextPos(2) = XTextPos(2)-XTextExt(4);
            YTextPos(1) = YTextPos(1)-YTextExt(4);
        end

        set(obj.hXText,'Position',XTextPos);
        set(obj.hYText,'Position',YTextPos);
        
        set([obj.hXText,obj.hYText],'Units',prevUnits);

        
        %Set final properties    
        set([obj.hXLine,obj.hYLine],'LineWidth',obj.LineWidth,'Color',obj.Color);
        
        %Define container handle for all components for easy manipulation
        obj.hScalebar = [obj.hXLine,obj.hYLine,obj.hXText,obj.hYText];
        
        
    end %constructor   
    
    function delete(obj)
        delete(obj.hXText);
        delete(obj.hYText);
        delete(obj.hXLine);
        delete(obj.hYLine);
        obj = [];
        clear obj;
    end
%===============================================================================

    function obj = set.Visible(obj,state)
        if strcmpi(state,'on') 
            set(obj.hScalebar,'Visible','on');
        elseif strcmpi(state,'off')
            set(obj.hScalebar,'Visible','off');
        end
    end
    
    function obj = set.Labels(obj,state)
        if strcmpi(state,'on')
            set(obj.hXText,'Visible','on');
            set(obj.hYText,'Visible','on');
        elseif strcmpi(state,'off')
            set(obj.hXText,'Visible','off');
            set(obj.hYText,'Visible','off');
        end
    end
           
         
end %methods

%===============================================================================
end %classdef

