def unique_word_count(text)
  split_text = text.downcase.split(/[^\w']+/)
  split_text.each_with_object(Hash.new(0)) { |word, count| count[word] += 1 }.to_a
end