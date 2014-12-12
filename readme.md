SCALEBAR 
Creates an integrated XY scalebar object on a data plot.

scalebar()                 =>  Creates scalebar on the current axis.

scalebar(haxis)            =>  Creates scalebar on the axis with handle haxis.

scalebar(haxis,'Property',value) => Creates a scalebar on the designated axis
                                    with properties defined the by the 
                                    property-value pairing.

Properties are as follows (defaults are enclosed in brackets):

  

  'XLen' or 'YLen'        Length of X or Y scalebars.  Defaults to 10% of 
                          axis length.

  'XString' or 'YString'  String to place alongside each scalebar.  Default is
                          the concatenated length and units.

  'XUnits' or 'YUnits'    Units to include in the string label.

  'Location'              'UR' ['LR'] 'LL' 'UL'
                          Location of scalebar. Default is lower right (LR).
                          Can also place in upper right(UR), lower left(LL),
                          and upper left(UL).                         

  'Position'              [X Y]
                          Position of the scale bar.  Enter a precise position
                          in axis coordinates to override the default location
                          and position the scalebar anywhere within plot. The
                          position is defined as meeting point of XY 
                          scale bars.

  'Orientation'           Orientation of vertical Y bar relative to X bar.
                          'Right' orientation indicates Y bar is at right-most
                          end of X bar. 'Left' orientation indicates that Y 
                          bar is at left-most end.  Default is 'right'.
    'FontName'              Set font attributes for text labels.             
    'FontSize'
    'FontWeight'
    'FontAngle'

    'Visible'               Turn 'on' or 'off' entire scalebar object.

    'Labels'                Turn 'on' or 'off' text labels.




Notes

-Currently being tested.

-SET/GET functions for scalebar properties are not currently implemented,
 requiring that a new scalebar be created to change appearance, etc.  This will
 be implemented soon.

-The 'SET method for a non-dependent property...' warning is ignored, as all 
 properties are given default values upon first instantiation of the class.


MJRusso 11/2014
