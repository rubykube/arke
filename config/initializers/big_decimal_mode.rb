# frozen_string_literal: true

# round towards the nearest neighbor, unless both neighbors are equidistant,
# in which case round towards the even neighbor (Banker's rounding)
BigDecimal.mode(BigDecimal::ROUND_MODE, BigDecimal::ROUND_HALF_EVEN)
