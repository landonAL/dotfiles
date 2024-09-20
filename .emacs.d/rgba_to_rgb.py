def rgba_to_rgb(hex_color):
    # Assuming a white background, so the background RGB is (255, 255, 255)
    background_r, background_g, background_b = 255, 255, 255
    
    # Extract RGBA from hex
    r = int(hex_color[1:3], 16)
    g = int(hex_color[3:5], 16)
    b = int(hex_color[5:7], 16)
    a = int(hex_color[7:9], 16) / 255.0  # Convert to a scale of 0 to 1

    # Calculate new RGB by blending the original color with the background
    new_r = round((1 - a) * background_r + a * r)
    new_g = round((1 - a) * background_g + a * g)
    new_b = round((1 - a) * background_b + a * b)

    # Convert RGB back to hex
    return f"#{new_r:02X}{new_g:02X}{new_b:02X}"

colors = [
    "#BFC9DBFF", # Default
    "#87919DFF", # Comment
    "#82AAA3FF", # Type
    "#D0C5A9FF", # Function
    "#BFC9DBFF", # Punctuation
    "#E0AD82FF", # Operation
    "#D4BC7DFF", # String
    "#D699B5FF", # Value
    "#D89B75FF", # Highlight
    "#FF0000FF", # Error
    "#E4D97DFF", # Warning
    "#E67D74FF", # Keyword
]

for color in colors:
    converted = rgba_to_rgb(color)
    print(f"{color} -> {converted}")