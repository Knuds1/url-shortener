shorturls = [
  { url: 'foo', target: 'bar' }
]

shorturls.each do |u|
  Shorturls.create(u)
end
