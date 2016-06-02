def createPhoneNumber(array)
  return "(#{array[0..2].join("")})#{array[3..5].join("")}-#{array[6..9].join("")}"
end

