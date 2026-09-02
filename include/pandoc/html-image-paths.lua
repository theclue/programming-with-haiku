function Image(image)
  if image.src:sub(1, 10) == "../images/" then
    image.src = image.src:sub(4)
  end
  return image
end
