# Design Aesthetics Library

100 distinct design aesthetics for frontend implementations. Select based on project context, brand personality, and target audience — not defaults.

**Usage:** When asked for multiple design variants, SELECT FROM DIFFERENT CATEGORIES. Never repeat the same 5 aesthetics.

---

## Editorial & Publishing (1-10)

### 1. New York Times Editorial
Confident serif typography, high-contrast black/cream, dramatic pull quotes, generous line height, restrained imagery with strong photography. Grid-based with intentional breaks.
```css
--font-display: "Cheltenham", Georgia, serif;
--bg: #FAF9F7; --text: #121212; --accent: #567B95;
```

### 2. Kinfolk Lifestyle
Extreme whitespace, lowercase headings, muted earth palette, slow photography, quiet elegance. Typography is breathing room.
```css
--font: "Canela", serif; --spacing: clamp(3rem, 8vw, 8rem);
--bg: #F5F3EF; --text: #2D2D2D;
```

### 3. Bloomberg Terminal
Information-dense, data-forward, monospace accents, high-contrast color coding, dark mode default, financial severity.
```css
--font: "IBM Plex Mono", monospace;
--bg: #0D0D0D; --text: #FFFFFF; --positive: #00E676; --negative: #FF5252;
```

### 4. Vogue Fashion
Ultra-thin serifs, dramatic scale contrast, fashion photography bleeds, luxurious negative space, stark black on white.
```css
--font-display: "Didot", "Bodoni MT", serif;
--letter-spacing: 0.3em; --text-transform: uppercase;
```

### 5. Monocle Magazine
Sophisticated grid, numbered sections, confident color blocks, international modernism, information hierarchy.
```css
--font: "Plantin", Georgia, serif; --grid: 12-column;
--accent: #D4AF37; --bg: #FFFFFF;
```

### 6. The Outline Digital
Vibrant neon on dark, anti-establishment energy, bold sans-serif, animated gradients, punk editorial.
```css
--bg: #0A0A0A; --accent: #FF6B35;
--gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

### 7. Architectural Digest
Luxury editorial, oversized imagery, minimal text intervention, sophisticated serif/sans pairing, gallery-like presentation.
```css
--font-display: "Freight Display", serif;
--font-body: "Graphik", sans-serif;
```

### 8. SSENSE Editorial
Fashion-forward minimalism, asymmetric layouts, editorial photography, crisp sans-serif, stark contrast.
```css
--font: "Helvetica Neue", Arial, sans-serif;
--bg: #FFFFFF; --text: #000000; --hover: #666666;
```

### 9. It's Nice That
Playful editorial, bold color splashes, creative confidence, mixed typography, design-industry insider energy.
```css
--font-display: "GT America", sans-serif;
--accent: #0000FF; --secondary: #FF00FF;
```

### 10. Eye on Design (AIGA)
Designer-for-designers, typographic experimentation, confident color, design discourse aesthetic.
```css
--font: "Söhne", "Helvetica Neue", sans-serif;
--accent: #FF4D00;
```

---

## Tech & SaaS (11-25)

### 11. Linear App
Precision engineering aesthetic, subtle gradients, dark with purple accents, pixel-perfect, obsessive attention to detail.
```css
--bg: #0A0B0D; --surface: #1A1B1E;
--accent: #5E6AD2; --text: #FFFFFF;
```

### 12. Vercel Black
Pure black canvas, white typography, monospace code blocks, terminal-inspired, developer confidence.
```css
--bg: #000000; --text: #FFFFFF;
--font-mono: "Geist Mono", monospace;
```

### 13. Stripe Gradient
Colorful gradients, animated mesh backgrounds, clean interface, blue-to-purple brand palette, financial trust.
```css
--gradient: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
--bg: #0A2540;
```

### 14. Notion Warmth
Off-white warmth, emoji as design element, hand-drawn illustrations, approachable productivity, sepia photography.
```css
--bg: #FFFFFF; --surface: #F7F6F3;
--text: #37352F; --accent: #2EAADC;
```

### 15. Figma Playful
Bright primary colors, geometric shapes, playful illustrations, creative tool energy, collaborative spirit.
```css
--red: #F24E1E; --orange: #FF7262; --purple: #A259FF;
--green: #0ACF83; --blue: #1ABCFE;
```

### 16. Raycast Command
Command palette aesthetic, keyboard-first, monospace, dark with subtle glow, developer productivity.
```css
--bg: #1A1A1A; --surface: #262626;
--accent: #FF6363; --border: rgba(255,255,255,0.1);
```

### 17. Arc Browser
Vibrant gradients, rounded everything, spatial computing feel, playful professionalism.
```css
--gradient: linear-gradient(135deg, #FF6B6B, #FF8E53, #FFD93D);
--radius: 1rem; --blur: 20px;
```

### 18. Superhuman Luxury
Email luxury, keyboard shortcuts prominent, dark with gold accents, speed-obsessed, executive aesthetic.
```css
--bg: #1A1A1A; --accent: #D4AF37;
--text: #FFFFFF; --muted: #666666;
```

### 19. Cal.com Open Source
Clean scheduling, accessibility-first, trustworthy neutrals, open-source pride.
```css
--bg: #FFFFFF; --surface: #F3F4F6;
--accent: #000000; --text: #111827;
```

### 20. Resend Developer
Email for developers, minimal purple accents, code-first presentation, modern developer tooling.
```css
--bg: #000000; --accent: #8B5CF6;
--font-mono: "JetBrains Mono", monospace;
```

### 21. Planetscale Database
Database visualization, branching metaphor, green/teal palette, technical confidence.
```css
--bg: #000000; --accent: #00D9FF;
--surface: #111111;
```

### 22. Clerk Auth
Auth provider aesthetic, secure feeling, purple gradients, developer-friendly.
```css
--accent: #6C47FF; --bg: #FAFAFA;
--surface: #FFFFFF;
```

### 23. Convex Real-time
Real-time visualization, reactive data flows, orange energy, modern backend.
```css
--accent: #F97316; --bg: #0C0A09;
--gradient: linear-gradient(135deg, #F97316, #FB923C);
```

### 24. Supabase Green
Firebase alternative, green everywhere, open-source pride, PostgreSQL elegance.
```css
--accent: #3ECF8E; --bg: #1C1C1C;
--surface: #2D2D2D;
```

### 25. Railway Deploy
Deploy infrastructure, purple gradients, developer experience focus, command line aesthetic.
```css
--bg: #13111C; --accent: #C049FF;
--gradient: linear-gradient(135deg, #C049FF, #844FFC);
```

---

## Luxury & High-End (26-40)

### 26. Hermès Artisan
Rich orange on cream, hand-crafted details, illustration-forward, brand heritage, timeless luxury.
```css
--orange: #F37021; --cream: #F6F1EB;
--font: "Orator", serif;
```

### 27. Cartier Red
Crimson on ivory, jewelry photography, extreme elegance, serif typography, French luxury.
```css
--red: #9D1B2F; --bg: #FAF8F5;
--font: "Didot", serif;
```

### 28. Rolex Precision
Deep green/gold palette, watch photography, Swiss precision, understated excellence.
```css
--green: #006039; --gold: #B4975A;
--bg: #FFFFFF;
```

### 29. Porsche Engineering
Automotive precision, dramatic angles, performance visualization, German engineering.
```css
--red: #D5001C; --bg: #000000;
--font: "Porsche Next", sans-serif;
```

### 30. Aesop Apothecary
Amber/brown warmth, ingredient-focused, apothecary aesthetic, tactile textures.
```css
--amber: #BA8B5E; --bg: #F7F5F3;
--text: #252525;
```

### 31. Tom Ford Night
Deep black, gold accents, masculine luxury, cinematic lighting, nocturnal elegance.
```css
--bg: #0A0A0A; --gold: #C9A962;
--font: "Bodoni", serif;
```

### 32. Bottega Green
Signature green leather, woven texture reference, Italian craft, understated wealth.
```css
--green: #3D6B4F; --bg: #F5F5F0;
--texture: url('/weave-pattern.svg');
```

### 33. Chanel Monochrome
Black and white only, interlocking C patterns, Parisian sophistication, timeless fashion.
```css
--bg: #FFFFFF; --text: #000000;
--font: "Galano Grotesque", sans-serif;
```

### 34. Four Seasons Hospitality
Warm neutrals, serene imagery, hospitality warmth, refined service aesthetic.
```css
--bg: #FAF8F5; --accent: #8B7355;
--font: "Chronicle Display", serif;
```

### 35. Aman Resorts
Extreme minimalism, zen-like whitespace, serene photography, spiritual luxury.
```css
--bg: #FFFFFF; --text: #3D3D3D;
--spacing: clamp(4rem, 10vw, 12rem);
```

### 36. Patek Philippe Heritage
Watchmaking heritage, navy and gold, generational wealth aesthetic, museum quality.
```css
--navy: #1A2744; --gold: #B4975A;
--font: "Times New Roman", serif;
```

### 37. Valentino Drama
High-fashion red, dramatic photography, editorial boldness, Italian drama.
```css
--red: #B01D1D; --bg: #FAF7F2;
--contrast: extreme;
```

### 38. Tiffany Blue
Signature robin's egg blue, jewelry presentation, romantic luxury, gift-giving aesthetic.
```css
--tiffany: #0ABAB5; --bg: #FFFFFF;
--accent: #000000;
```

### 39. Bang & Olufsen Audio
Danish design, aluminum/black palette, audio visualization, minimalist luxury.
```css
--bg: #000000; --surface: #1A1A1A;
--accent: #B4975A;
```

### 40. Rolls-Royce Motor
Coach-building heritage, deep purple/silver, automotive photography, bespoke luxury.
```css
--purple: #281432; --silver: #C0C0C0;
--bg: #0D0D0D;
```

---

## Creative & Agency (41-55)

### 41. Pentagram Identity
Case study focused, dramatic project reveals, confident typography, design authority.
```css
--bg: #FFFFFF; --text: #000000;
--grid: masonry; --transition: 0.6s cubic-bezier(0.16, 1, 0.3, 1);
```

### 42. Studio Dumbar Dutch
Experimental layouts, bold color, Dutch design heritage, conceptual work.
```css
--primary: #0000FF; --secondary: #FF0000;
--layout: asymmetric;
```

### 43. Sagmeister & Walsh Provocative
Artistic provocation, mixed media, hand-crafted digital, memorable visuals.
```css
--palette: dynamic; --imagery: conceptual;
--typography: experimental;
```

### 44. R/GA Digital
Digital innovation, tech-meets-creativity, data visualization, futuristic optimism.
```css
--bg: #0D0D0D; --accent: #00FF88;
--gradient: mesh;
```

### 45. Work & Co Product
Product design showcase, clean interface documentation, systematic presentation.
```css
--bg: #F5F5F5; --surface: #FFFFFF;
--accent: #000000;
```

### 46. Huge Brooklyn
Brooklyn creative energy, bold statements, startup-meets-agency aesthetic.
```css
--accent: #FF4136; --bg: #FFFFFF;
--font-display: "GT America Extended", sans-serif;
```

### 47. MediaMonks Craft
Award-winning craft, technical excellence, creative technology showcase.
```css
--bg: #1A1A1A; --accent: #FFD700;
--animation: complex;
```

### 48. Basic/Dept
Clean portfolio grid, minimal intervention, work speaks for itself aesthetic.
```css
--bg: #FFFFFF; --text: #000000;
--grid: tight; --hover: reveal;
```

### 49. Studio Feixen Swiss
Swiss precision, geometric shapes, playful color, motion-forward.
```css
--primary: #0000FF; --shapes: geometric;
--animation: delightful;
```

### 50. Anti-Agency Brutalist
Raw HTML energy, no framework aesthetic, anti-polish statement, honest web.
```css
--font: "Times New Roman", serif;
--bg: #FFFFFF; --border: 2px solid #000000;
```

### 51. Fantasy Interactive
Big brand work, case study immersion, high production values.
```css
--bg: #0A0A0A; --type-scale: dramatic;
--scroll: smooth;
```

### 52. Wieden+Kennedy Portland
Just Do It energy, brand storytelling, sports and culture, bold typography.
```css
--font: "Futura Bold", sans-serif;
--contrast: maximum;
```

### 53. Wolff Olins Identity
Brand transformation, strategic design, identity systems showcase.
```css
--bg: dynamic; --palette: brand-specific;
--grid: flexible;
```

### 54. Moving Brands Motion
Motion design showcase, animated case studies, dynamic presentations.
```css
--animation: everywhere; --bg: #000000;
--accent: variable;
```

### 55. ueno Iceland
Icelandic design, clean grids, confident color, friendly professionalism.
```css
--bg: #FFFFFF; --accent: #FF3366;
--font: "Circular", sans-serif;
```

---

## Cultural & Arts (56-70)

### 56. MoMA Exhibition
Museum white, artwork showcase, educational clarity, cultural institution.
```css
--bg: #FFFFFF; --text: #000000;
--font: "Franklin Gothic", sans-serif;
```

### 57. Tate Gallery Digital
Contemporary art, bold typography, artistic experimentation, institutional innovation.
```css
--bg: #FFFFFF; --accent: #000000;
--layout: editorial;
```

### 58. Walker Art Center
Minnesota cool, experimental typography, contemporary culture, design-forward museum.
```css
--font: custom variable; --bg: #FFFFFF;
--accent: contextual;
```

### 59. Spotify Wrapped
Data visualization, personal statistics, vibrant gradients, year-in-review energy.
```css
--gradient: radial-gradient(ellipse at top, #1DB954, #191414);
--animation: reveal;
```

### 60. Apple Keynote
Product reveal, dramatic lighting, precision animations, premium technology.
```css
--bg: #000000; --text: #FFFFFF;
--animation: orchestrated;
```

### 61. Nike Training
Athletic energy, performance visualization, motivational typography, swoosh integration.
```css
--bg: #000000; --accent: #FF6B00;
--font: "Nike Futura", sans-serif;
```

### 62. National Geographic
Documentary photography, yellow frame, exploration narrative, educational wonder.
```css
--yellow: #FFCC00; --bg: #000000;
--imagery: full-bleed;
```

### 63. New Museum Contemporary
White cube digital, artist-forward, exhibition documentation, curatorial voice.
```css
--bg: #FFFFFF; --text: #000000;
--spacing: museum;
```

### 64. Criterion Collection
Film preservation, classic cinema, collector aesthetic, curated excellence.
```css
--bg: #FFFFFF; --accent: #000000;
--border: distinctive;
```

### 65. The Met Archive
Cultural heritage, artifact documentation, scholarly presentation, institutional gravitas.
```css
--bg: #F7F5F2; --accent: #C41E3A;
--font: "Plantin", serif;
```

### 66. Whitney Museum
American art, stacked logo reference, contemporary programming, NYC cultural.
```css
--bg: #FFFFFF; --text: #000000;
--font: "Neue Haas Grotesk", sans-serif;
```

### 67. Cooper Hewitt Design
Design museum, educational interaction, object-focused, Smithsonian heritage.
```css
--accent: #FFD200; --bg: #FFFFFF;
--interaction: exploratory;
```

### 68. V&A Museum
Decorative arts, Victorian heritage, digital collection, British institution.
```css
--bg: #FAFAFA; --accent: #E4002B;
--grid: collection;
```

### 69. Serpentine Galleries
Pavilion architecture, contemporary art, London cultural, digital exhibitions.
```css
--bg: #FFFFFF; --text: #000000;
--layout: experimental;
```

### 70. Centre Pompidou
Inside-out architecture, French modernism, bold color coding, cultural programming.
```css
--red: #E30613; --blue: #0066B3;
--green: #00A651; --yellow: #FFF200;
```

---

## Retro & Nostalgic (71-85)

### 71. Y2K Cyber
Metallic gradients, chrome text, cyber aesthetic, millennium nostalgia.
```css
--gradient: linear-gradient(135deg, #C0C0C0, #808080);
--font: "Eurostile", sans-serif; --effects: bevel;
```

### 72. 90s Web Brutalist
Under construction GIFs, visitor counters, Times New Roman, honest HTML.
```css
--bg: #808080; --text: #0000FF;
--border: inset 3px; --font: "Comic Sans MS";
```

### 73. Vaporwave Aesthetic
Pink/cyan gradients, Greek statues, VHS glitch, Japanese text, retro-futurism.
```css
--pink: #FF6AD5; --cyan: #00FFFF;
--bg: linear-gradient(#FF71CE, #01CDFE);
```

### 74. 70s Psychedelic
Orange/brown palette, groovy typography, organic shapes, flower power.
```css
--orange: #FF6B35; --brown: #8B4513;
--font: "Groovy", cursive; --shapes: organic;
```

### 75. Art Deco Gatsby
Gold geometric patterns, 1920s elegance, Gatsby glamour, jazz age.
```css
--gold: #D4AF37; --black: #1A1A1A;
--pattern: chevron; --font: "Poiret One";
```

### 76. Memphis Design
Bold geometric shapes, clashing colors, 80s Italian design, Sottsass energy.
```css
--pink: #FF69B4; --yellow: #FFE135;
--blue: #00BFFF; --pattern: squiggle;
```

### 77. Swiss International
Helvetica, grid system, red/white/black, Müller-Brockmann precision.
```css
--font: "Helvetica", sans-serif;
--grid: strict; --accent: #FF0000;
```

### 78. Bauhaus Functional
Primary colors, geometric shapes, form follows function, modernist purity.
```css
--red: #E30613; --blue: #0033A0;
--yellow: #FFCC00; --font: "Universal";
```

### 79. Mid-Century Modern
Atomic age, boomerang shapes, teak tones, Eames aesthetic.
```css
--orange: #E85D04; --teal: #14746F;
--bg: #FFF8E7;
```

### 80. Cassette Culture
Tape deck aesthetic, Walkman era, neon on black, audio visualization.
```css
--bg: #1A1A1A; --accent: #FF00FF;
--texture: noise;
```

### 81. VHS Tracking
CRT scan lines, tracking errors, VCR timestamps, analog glitch.
```css
--effects: scanlines; --color-bleed: true;
--font: "VCR OSD Mono";
```

### 82. Newspaper Print
Newsprint texture, column layout, halftone images, ink bleed effect.
```css
--bg: #F5F5DC; --text: #1A1A1A;
--texture: newsprint; --columns: 4;
```

### 83. Neon Noir
Rainy city aesthetic, neon reflections, cyberpunk lighting, Blade Runner mood.
```css
--bg: #0D0D0D; --neon-pink: #FF2D95;
--neon-blue: #00D9FF; --rain: overlay;
```

### 84. Pixel Art 8-bit
Retro gaming, pixel fonts, limited palette, chiptune energy.
```css
--font: "Press Start 2P"; --pixels: crisp;
--palette: 16-color;
```

### 85. Polaroid Instant
Photo frame borders, handwritten captions, vintage photography, memory aesthetic.
```css
--bg: #FAF7F2; --frame: #FFFFFF;
--shadow: 0 4px 6px rgba(0,0,0,0.1);
```

---

## Experimental & Avant-Garde (86-100)

### 86. Deconstructed Grid
Broken layouts, overlapping elements, intentional chaos, graphic design school.
```css
--grid: none; --overlap: intentional;
--typography: fragmented;
```

### 87. Kinetic Typography
Text as motion, animated letterforms, scroll-triggered type, GSAP showcase.
```css
--animation: text-reveal; --scroll: trigger;
--split: chars;
```

### 88. Three.js Immersive
WebGL experiences, 3D navigation, spatial computing preview, technical showcase.
```css
--canvas: fullscreen; --interaction: spatial;
--performance: optimized;
```

### 89. Noise Grain Texture
Film grain overlay, analog warmth, texture-rich, tactile digital.
```css
--noise: url('/noise.svg'); --blend: overlay;
--opacity: 0.05;
```

### 90. Cursor Playground
Custom cursors, interaction delight, hover states as content, playful UX.
```css
--cursor: custom; --hover: transform;
--interaction: magnetic;
```

### 91. Scroll Hijack Cinema
Storytelling through scroll, narrative control, cinematic pacing, immersive experience.
```css
--scroll: controlled; --animation: timeline;
--sections: full-viewport;
```

### 92. Variable Font Play
Font-width animation, responsive typography, axis manipulation, type as experience.
```css
--font: variable; --animation: font-weight;
--axis: wght wdth slnt;
```

### 93. Cursor Trail Magic
Following particles, mouse trails, interactive particles, delightful motion.
```css
--particles: mouse-follow; --canvas: overlay;
--blend: screen;
```

### 94. Split Screen Duality
Two-sided narratives, comparison layouts, before/after, dual perspectives.
```css
--layout: split; --interaction: slide;
--contrast: deliberate;
```

### 95. ASCII Art Interface
Text-based UI, terminal aesthetic, character art, hacker culture.
```css
--font: "Fira Code", monospace;
--characters: box-drawing; --bg: #0D1117;
```

### 96. Morphing Shapes
Blob animations, organic transformations, SVG morphing, fluid design.
```css
--shapes: blob; --animation: morph;
--filter: gooey;
```

### 97. Parallax Depth
Z-axis layering, depth perception, scroll-based 3D, dimensional design.
```css
--perspective: 1000px; --layers: multiple;
--scroll: parallax;
```

### 98. Monochrome Dramatic
Single color + black/white, dramatic contrast, bold simplicity, statement design.
```css
--accent: single; --bg: #000000;
--text: #FFFFFF;
```

### 99. Data Viz Art
Information as beauty, chart aesthetics, statistical storytelling, D3.js showcase.
```css
--visualization: custom; --data: real;
--animation: reactive;
```

### 100. Anti-Design Chaos
Intentional ugliness, rule-breaking, punk aesthetic, beautiful destruction.
```css
--rules: broken; --typography: clashing;
--colors: jarring; --layout: chaotic;
```

---

## Selection Guidelines

**For redesign variants, rotate through categories:**
- Don't pick 5 from the same category
- Match aesthetic to client industry/audience
- Consider competitor differentiation
- Test light AND dark modes for each

**Category by project type:**

| Project Type | Best Categories |
|--------------|-----------------|
| SaaS/Tech | Tech & SaaS, Experimental |
| E-commerce Luxury | Luxury & High-End, Editorial |
| Restaurant/Food | Retro, Cultural, Luxury |
| Portfolio/Agency | Creative & Agency, Experimental |
| Local Business | Editorial, Cultural, Retro |
| Finance | Tech, Luxury, Editorial |
| Healthcare | Tech, Cultural, Editorial |
| Entertainment | Retro, Experimental, Cultural |

**Never default to:**
- Minimal Editorial + Bold Playful + Mountain Modern + Warm Community + Tech Forward

These 5 are banned as a set. Pick from the full 100.
