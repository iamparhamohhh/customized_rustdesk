"""
Generate all icon/logo files for RahbarDesk from the source logo image.
Usage: python generate_icons.py <source_image_path>
"""
import sys
import os
from PIL import Image, ImageDraw

def make_square_icon(source_img, size, padding_pct=0.05):
    """
    Create a square icon from source image.
    Centers the logo on a transparent background with optional padding.
    """
    # Work with RGBA
    img = source_img.copy().convert("RGBA")
    
    # Find the bounding box of the non-background content
    # The logo has a light/white background - detect the actual logo content
    pixels = img.load()
    w, h = img.size
    
    # Find bounding box of dark pixels (the actual logo)
    min_x, min_y, max_x, max_y = w, h, 0, 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            # The logo is dark navy (~51, 65, 79) on light background (~225+)
            # Consider a pixel as "content" if it's darker than a threshold
            if a > 128 and (r + g + b) / 3 < 180:
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
    
    if max_x <= min_x or max_y <= min_y:
        # Fallback: use entire image
        cropped = img
    else:
        # Add a small margin around the detected content
        margin = int(min(w, h) * 0.02)
        min_x = max(0, min_x - margin)
        min_y = max(0, min_y - margin)
        max_x = min(w, max_x + margin)
        max_y = min(h, max_y + margin)
        cropped = img.crop((min_x, min_y, max_x, max_y))
    
    # Make it square by padding the shorter dimension
    cw, ch = cropped.size
    sq_size = max(cw, ch)
    square = Image.new("RGBA", (sq_size, sq_size), (0, 0, 0, 0))
    offset_x = (sq_size - cw) // 2
    offset_y = (sq_size - ch) // 2
    square.paste(cropped, (offset_x, offset_y))
    
    # Apply padding
    if padding_pct > 0:
        padded_size = int(sq_size / (1 - 2 * padding_pct))
        padded = Image.new("RGBA", (padded_size, padded_size), (0, 0, 0, 0))
        pad = (padded_size - sq_size) // 2
        padded.paste(square, (pad, pad))
        square = padded
    
    # Resize to target
    return square.resize((size, size), Image.LANCZOS)


def make_logo_banner(source_img, max_width=300, max_height=60):
    """
    Create a horizontal logo image for the about/settings page.
    Keeps aspect ratio, fits within max_width x max_height.
    """
    img = source_img.copy().convert("RGBA")
    
    # Find content bounds (same as above)
    pixels = img.load()
    w, h = img.size
    min_x, min_y, max_x, max_y = w, h, 0, 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a > 128 and (r + g + b) / 3 < 180:
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
    
    if max_x <= min_x or max_y <= min_y:
        cropped = img
    else:
        margin = int(min(w, h) * 0.02)
        min_x = max(0, min_x - margin)
        min_y = max(0, min_y - margin)
        max_x = min(w, max_x + margin)
        max_y = min(h, max_y + margin)
        cropped = img.crop((min_x, min_y, max_x, max_y))
    
    # Scale to fit within max_width x max_height
    cw, ch = cropped.size
    scale = min(max_width / cw, max_height / ch)
    new_w = int(cw * scale)
    new_h = int(ch * scale)
    
    result = cropped.resize((new_w, new_h), Image.LANCZOS)
    return result


def create_ico(source_img, output_path, sizes=[16, 24, 32, 48, 64, 128, 256]):
    """Create a multi-resolution ICO file."""
    icons = []
    for s in sizes:
        icon = make_square_icon(source_img, s, padding_pct=0.08)
        icons.append(icon)
    
    # Save as ICO with multiple sizes
    icons[0].save(output_path, format='ICO', sizes=[(s, s) for s in sizes],
                  append_images=icons[1:])


def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_icons.py <source_image_path>")
        sys.exit(1)
    
    source_path = sys.argv[1]
    if not os.path.exists(source_path):
        print(f"Error: {source_path} not found")
        sys.exit(1)
    
    source = Image.open(source_path)
    print(f"Source image: {source.size[0]}x{source.size[1]} {source.mode}")
    
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(base_dir)
    flutter_dir = os.path.join(project_dir, "flutter")
    
    # --- res/ directory icons ---
    print("Generating res/ icons...")
    
    # icon.png (512x512 - high quality source)
    icon_512 = make_square_icon(source, 512, padding_pct=0.08)
    icon_512.save(os.path.join(base_dir, "icon.png"), "PNG")
    print("  icon.png (512x512)")
    
    # 32x32, 64x64, 128x128, 128x128@2x (256x256)
    for size, name in [(32, "32x32.png"), (64, "64x64.png"), 
                       (128, "128x128.png"), (256, "128x128@2x.png")]:
        icon = make_square_icon(source, size, padding_pct=0.08)
        icon.save(os.path.join(base_dir, name), "PNG")
        print(f"  {name} ({size}x{size})")
    
    # mac-icon.png (1024x1024)
    mac_icon = make_square_icon(source, 1024, padding_pct=0.08)
    mac_icon.save(os.path.join(base_dir, "mac-icon.png"), "PNG")
    print("  mac-icon.png (1024x1024)")
    
    # ICO files
    print("Generating ICO files...")
    create_ico(source, os.path.join(base_dir, "icon.ico"))
    print("  icon.ico")
    create_ico(source, os.path.join(base_dir, "tray-icon.ico"), sizes=[16, 24, 32, 48])
    print("  tray-icon.ico")
    
    # --- flutter/windows/runner/resources/ ---
    flutter_win_res = os.path.join(flutter_dir, "windows", "runner", "resources")
    os.makedirs(flutter_win_res, exist_ok=True)
    create_ico(source, os.path.join(flutter_win_res, "app_icon.ico"))
    print("  flutter/windows/runner/resources/app_icon.ico")
    
    # --- flutter/assets/ ---
    flutter_assets = os.path.join(flutter_dir, "assets")
    os.makedirs(flutter_assets, exist_ok=True)
    
    # icon.png for flutter (256x256 is good for in-app use)
    icon_256 = make_square_icon(source, 256, padding_pct=0.08)
    icon_256.save(os.path.join(flutter_assets, "icon.png"), "PNG")
    print("  flutter/assets/icon.png (256x256)")
    
    # logo.png for flutter (used in About dialog, max 300x60)
    logo = make_logo_banner(source, max_width=600, max_height=120)
    logo.save(os.path.join(flutter_assets, "logo.png"), "PNG")
    print(f"  flutter/assets/logo.png ({logo.size[0]}x{logo.size[1]})")
    
    # --- Android icons ---
    android_res = os.path.join(flutter_dir, "android", "app", "src", "main", "res")
    android_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    if os.path.exists(android_res):
        print("Generating Android icons...")
        for folder, size in android_sizes.items():
            folder_path = os.path.join(android_res, folder)
            os.makedirs(folder_path, exist_ok=True)
            icon = make_square_icon(source, size, padding_pct=0.08)
            icon.save(os.path.join(folder_path, "ic_launcher.png"), "PNG")
            print(f"  {folder}/ic_launcher.png ({size}x{size})")
    
    # --- iOS icons ---
    ios_assets = os.path.join(flutter_dir, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
    if os.path.exists(ios_assets):
        print("Generating iOS icons...")
        ios_sizes = [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024]
        for size in ios_sizes:
            icon = make_square_icon(source, size, padding_pct=0.08)
            icon.save(os.path.join(ios_assets, f"Icon-App-{size}x{size}.png"), "PNG")
        print(f"  Generated {len(ios_sizes)} iOS icon sizes")
    
    print("\nDone! All icons generated successfully.")


if __name__ == "__main__":
    main()
