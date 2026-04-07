# Image Generation Skill

Generate amazing images using AI with optimized prompts.

## Nano Banana Pro (Gemini)

**URL:** https://gemini.google.com/u/1/app

### How to Use
1. Open the browser to the URL above
2. Type your image prompt in the chat
3. Gemini will generate images

### Downloading Full Size Images
1. After images are generated, click on an image to open it
2. Right-click the image and select "Open image in new tab" or look for a download button
3. In the new tab, right-click and "Save image as..." to download full resolution
4. Or use browser screenshot for quick capture

## Prompt Engineering Tips

### Structure
```
[Subject] + [Style] + [Lighting] + [Composition] + [Details] + [Quality Modifiers]
```

### Quality Modifiers (add these)
- `highly detailed`
- `8k resolution`
- `photorealistic` (for photos)
- `professional photography`
- `cinematic lighting`
- `sharp focus`
- `award-winning`

### Style Keywords
- **Photographic:** natural lighting, DSLR, 85mm lens, shallow depth of field, bokeh
- **Artistic:** oil painting, watercolor, digital art, concept art, illustration
- **Cinematic:** dramatic lighting, film still, movie scene, epic composition
- **Minimal:** clean, simple, white background, product photography

### Effective Prompts Examples

**Portrait:**
```
Professional headshot of a confident business woman, natural lighting, 
shallow depth of field, 85mm lens, neutral background, sharp focus, 
high resolution, professional photography
```

**Product:**
```
Minimalist product photography of a sleek smartphone on marble surface, 
soft studio lighting, clean white background, reflections, 8k, 
commercial quality, sharp details
```

**Landscape:**
```
Breathtaking mountain landscape at golden hour, dramatic clouds, 
snow-capped peaks, alpine meadow foreground, cinematic composition, 
National Geographic style, 8k resolution
```

**Abstract/Creative:**
```
Surreal dreamscape with floating islands, bioluminescent plants, 
ethereal mist, fantasy art style, vibrant colors, highly detailed, 
concept art quality, magical atmosphere
```

### What to Avoid
- Vague descriptions ("nice picture")
- Too many competing elements
- Contradictory styles
- Overly complex scenes with too many subjects

### Iterating on Prompts
1. Start simple, add details gradually
2. Note what works, refine what doesn't
3. Use specific artists or styles as references
4. Include negative descriptors if needed ("no text", "no watermarks")

## Other Image Gen Tools

### DALL-E (OpenAI)
- Via ChatGPT Plus or API
- Good for creative/artistic images

### Midjourney
- Discord-based
- Excellent for artistic styles
- Parameters: --ar (aspect ratio), --v (version), --q (quality)

### Stable Diffusion
- Local or API
- Highly customizable
- Many model variants

## Upscaling with ~/bin/upscale

After generating, use the `upscale` CLI wrapper for higher resolution:

```bash
# Basic usage (outputs input-4x.png with ultrasharp model)
upscale photo.png

# Specify output filename
upscale photo.png photo-highres.png

# Use different model
upscale art.png art-4x.png digital-art-4x
```

### Available Models
- `ultrasharp-4x` — Best for photos (default)
- `high-fidelity-4x` — Preserves fine details
- `remacri-4x` — General purpose
- `digital-art-4x` — Best for illustrations/AI art

## Complete Workflow

1. **Generate** — Use Nano Banana Pro (Gemini) or other tools
2. **Download** — Save full-resolution image from generator
3. **Upscale** — Run `upscale image.png` for 4x resolution
4. **Use** — Deploy to project

### Example: Hero Background Workflow
```bash
# 1. Generate via Gemini (browser)
# 2. Download to ~/Downloads/hero-raw.png
# 3. Upscale
upscale ~/Downloads/hero-raw.png ~/Projects/mysite/public/hero.png

# For dark/moody backgrounds, add to prompt:
# "dark atmosphere, moody lighting, deep shadows, cinematic"
```
