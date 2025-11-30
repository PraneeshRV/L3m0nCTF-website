
from PIL import Image
import os

# Path to uploaded image
input_path = "/home/crimson/.gemini/antigravity/brain/3b7c5a05-65e6-49d3-aa82-4fdc19ba2bca/uploaded_image_1764493421319.png"
# Output path
output_dir = "/home/crimson/Praneesh/L3m0nCTF-website/CTFd/themes/lemon/assets/img"
output_path = os.path.join(output_dir, "cursor.png")

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

try:
    img = Image.open(input_path)
    width, height = img.size
    
    # Assuming the two cursors are side-by-side and we want the first one (left half)
    # We can try to be smarter or just split in half.
    # Let's crop the left half.
    left_cursor = img.crop((0, 0, width // 2, height))
    
    # Trim transparency to make it tight
    bbox = left_cursor.getbbox()
    if bbox:
        left_cursor = left_cursor.crop(bbox)
        
    # Resize if too big? Standard cursor is usually 32x32 or similar.
    # Let's keep it reasonable, say max 32x32 or 64x64.
    # But high DPI screens might want larger. Let's check size.
    print(f"Original size: {img.size}")
    print(f"Cropped size: {left_cursor.size}")
    
    # Resize to 32x32 for standard cursor usage if it's huge
    # But let's save the high res version too if needed.
    # For CSS cursor, 32x32 is safe.
    left_cursor.thumbnail((32, 32), Image.Resampling.LANCZOS)
    
    left_cursor.save(output_path, "PNG")
    print(f"Saved cursor to {output_path}")
    
except Exception as e:
    print(f"Error: {e}")
