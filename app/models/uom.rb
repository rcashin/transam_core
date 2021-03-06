#
# Simple lookup class for distance metrics. Maybe used to add different
# measurement units as needed.
#
# This implementation wraps Unitwise but always extend this model rather
# than using Unitwise directly
#
#
class Uom

  # Other units
  UNIT                = 'unit'

  # Pre-defined weight quantities
  KILOGRAM            = 'kilogram'
  POUND               = "pound"
  SHORT_TON           = 'short ton'
  #TON                 = SHORT_TON
  TONNE               = "tonne"

  # Pre-defined area measurements
  SQUARE_FOOT         = "square foot"
  SQUARE_YARD         = "square yard"
  SQUARE_METER        = "square meter"
  SQUARE_MILE         = "square mile"
  ACRE                = "acre"

  # Predefined volumes
  LITER               = "liter"
  GALLON              = "gallon"

  # Pre-defined distance metrics that can be used to define linear distances
  INCH                = 'inch'
  FEET                = 'foot'
  YARD                = 'yard'
  MILE                = 'mile'
  METER               = 'meter'
  KILOMETER           = 'kilometer'

  # predefined weight over distance
  POUND_YARD          = 'lb/yd'
  POUND_INCH          = 'lb/in'
  CUBIC_YARD_MILE     = 'cu yd/mi'


  AREA_UNITS            = [SQUARE_FOOT, SQUARE_YARD, SQUARE_METER, SQUARE_MILE, ACRE]
  DISTANCE_UNITS        = [INCH, FEET, YARD, MILE, METER, KILOMETER]
  VOLUME_UNITS          = [LITER, GALLON]
  WEIGHT_UNITS          = [KILOGRAM, POUND, TONNE, SHORT_TON]
  WEIGHT_DISTANCE_UNITS = [POUND_YARD, POUND_INCH, CUBIC_YARD_MILE]
  OTHER_UNITS     = [UNIT]

  SI_UNITS        = [SQUARE_METER, METER, KILOMETER, LITER, KILOGRAM, TONNE]
  USC_UNITS       = [SQUARE_FOOT, SQUARE_YARD, SQUARE_MILE, ACRE, INCH, FEET, YARD, MILE, GALLON, POUND, SHORT_TON]
  
  # Returns an array of units
  def self.units
    OTHER_UNITS + AREA_UNITS + DISTANCE_UNITS + VOLUME_UNITS + WEIGHT_UNITS
  end

  def self.si_units
    OTHER_UNITS + SI_UNITS
  end

  def self.usc_units
    OTHER_UNITS + USC_UNITS
  end

  # Check to see if a measurement unit is valid
  def self.valid? uom
    Unitwise.valid? uom
  end

  # Convert a quantity from one unit to another
  def self.convert(quantity, from_uom, to_uom)
    begin
      Unitwise(quantity, from_uom).convert_to(to_uom).to_f
    rescue Exception
      raise ArgumentError.new('invalid argument')
    end
  end

end
