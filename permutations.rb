def permutations(string)
  split_string = string.split("")
  combinations = split_string.permutation.to_a
  combinations.select {|combo| p combo.join()}
  return nil
end

#without permutation method:

def permutation (string, i=0)
  puts string if i == string.length
  (i..string.length-1).each do |j|
    string[i], string[j] = string[j], string[i]
    permutation(string, i+1)
  end
end