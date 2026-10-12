# 🎨 VLC Redesign — خريطة طريق التصميم ومصفوفة شاشات Figma الكاملة (Design Roadmap)

> **المشروع:** إعادة تصميم واجهة وتجربة مستخدم VLC Media Player (VideoLAN) — إصدار الجيل الجديد.  
> **المرجع البصري:** ملف فيجما الرسمي `RJQ32w6ZIKvSgUvtpGKJUx` وتوثيق Jux التفصيلي (`transcript.md`).  
> **المبدأ الهندسي الصارم:** لا محاكاة صورية، لا ترقيع، بل بناء معمارية إنتاجية رسمية (Production Grade) تدمج التصميم في صلب كود Qt/QML لـ VLC.

---

## 🏛️ 1. هرمية رموز التصميم (3-Tier Semantic Design Token Hierarchy)

تطبيقاً لمعيار `creative-ui-and-visual-qa` و `ui-theme-designer`، يتم تقسيم كل الألوان والمسافات إلى 3 طبقات هندسية:

### المستوى الأول: الرموز الأولية (Tier 1: Global / Primitive Tokens)
- `--vlc-charcoal-900`: `#0F0F12` (الخلفية العميقة الأساسية)
- `--vlc-charcoal-800`: `#14151B` (أسطح الحاويات والألواح الجانبية)
- `--vlc-charcoal-700`: `#1C1D26` (العناصر البارزة والبطاقات)
- `--vlc-charcoal-600`: `#252733` (الحدود الفاصلة `rgba(255,255,255,0.08)`)
- `--vlc-orange-cone`: `#D37918` (لون قمع الـ VLC الأصلي المتوهج - Accent Main)
- `--vlc-orange-dim`: `#AB6314` (لون البرتقالي الخافت - Accent Dim)
- `--vlc-fg-primary`: `#FFFFFF` (النص الأبيض الأساسي)
- `--vlc-fg-secondary`: `#8F8F8F` (النص الفرعي والرموز المحايدة)
- `--vlc-glass-surface`: `rgba(20, 21, 27, 0.72)` (الزجاج المصقول مع Backdrop Blur)

### المستوى الثاني: الرموز الدلالية (Tier 2: Semantic Intent Tokens)
- `--surface-app`: `--vlc-charcoal-900`
- `--surface-sidebar`: `--vlc-charcoal-800`
- `--surface-card`: `--vlc-charcoal-700`
- `--border-subtle`: `--vlc-charcoal-600`
- `--accent-action`: `--vlc-orange-cone`
- `--accent-hover`: `#E68A27`
- `--text-main`: `--vlc-fg-primary`
- `--text-muted`: `--vlc-fg-secondary`
- `--seekbar-buffered`: `rgba(255, 255, 255, 0.25)`
- `--seekbar-active`: `--vlc-orange-cone`

### المستوى الثالث: رموز المكونات المخصصة (Tier 3: Component Scope Tokens)
- `--player-hero-play-size`: `44px`
- `--player-control-icon-size`: `24px`
- `--quick-sidebar-width`: `380px`
- `--seekbar-height-default`: `4px`
- `--seekbar-height-hover`: `8px`
- `--media-card-radius`: `10px`
- `--dialog-radius`: `12px`

---

## 📱 2. مصفوفة الشاشات والمكونات الرسمية في Figma (Master Screen Matrix)

تم تحليل وتوثيق كافة الشاشات والمكونات الموجودة في ملف Figma (`RJQ32w6ZIKvSgUvtpGKJUx`):

| المعرّف في Figma | اسم الشاشة / المكون | الوصف المعماري وتجربة المستخدم | الملف المستهدف في VLC |
| :--- | :--- | :--- | :--- |
| `#187:328` | **Player - Default** | واجهة المشغل الافتراضية مع شريط التحكم السفلي المدمج (Left Hero Play + Subtitle/Audio Popups) | `modules/gui/qt/player/qml/Player.qml` |
| `#247:445` | **Player - Active Video** | مشغل الفيديو أثناء العرض مع كانفاس الفيديو الحقيقي والـ OSD الشفاف | `modules/gui/qt/player/qml/Player.qml` |
| `#3328:11554` | **Player - Hide UI** | وضع المشاهدة الغامرة (Immersive Mode) مع اختفاء كافة عناصر التحكم تلقائياً | `modules/gui/qt/player/qml/Player.qml` |
| `#970:3308` | **Quick Settings Sidebar (Audio)** | الشريط الجانبي للإعدادات السريعة (380px) لضبط المعادل الصوتي والمؤثرات | `modules/gui/qt/player/qml/JuxQuickSettingsSidebar.qml` |
| `#970:3792` | **Quick Settings Sidebar (Video)** | الشريط الجانبي لضبط الألوان (Brightness, Contrast, Saturation, Crop) | `modules/gui/qt/player/qml/JuxQuickSettingsSidebar.qml` |
| `#970:2703` | **Quick Settings Sidebar (Subtitles/Sync)**| الشريط الجانبي لضبط تزامن الصوت والترجمة بالمللي ثانية | `modules/gui/qt/player/qml/JuxQuickSettingsSidebar.qml` |
| `#970:4028` | **Media Library View** | مكتبة الوسائط الحديثة بأسلوب Netflix/Spotify مع تصنيف الفيديو والصوت والمجلدات | `modules/gui/qt/medialibrary/qml/` |
| `#4767:23726` | **Player - Music Mode** | مشغل الصوتيات مع غلاف الألبوم، كلمات الأغاني (Lyrics)، وتصور الترددات (Visualizer) | `modules/gui/qt/player/qml/JuxMusicView.qml` |
| `#2107:5604` | **Toolbar Customizer Dialog** | نافذة تخصيص أشرطة الأدوات بالسحب والإفلات (Drag & Drop Toolbar Editor) | `modules/gui/qt/dialogs/` |
| `#1911:7545` | **Smart Subtitles Dialog** | نافذة مطابقة الترجمة الذكية التلقائية مع الحلقات والمجلدات (`S01E01`) | `modules/gui/qt/dialogs/` |
| `#999:5047` | **Settings - Global Hub** | مركز الإعدادات الشامل الجديد لجميع أقسام البرنامج الـ 12 | `modules/gui/qt/dialogs/` |
| `#2437:14832` | **Keyboard Shortcuts** | لوحة اختصارات لوحة المفاتيح التفاعلية | `modules/gui/qt/dialogs/` |
| `#6216:13614` | **Open Network Stream** | نافذة فتح وبث الروابط الشبكية (HLS, RTSP, YouTube, RTMP) | `modules/gui/qt/dialogs/` |
| `#6259:14954` | **New Playlist Dialog** | نافذة إنشاء وإدارة قوائم التشغيل السريعة | `modules/gui/qt/playlist/qml/` |
| `#42:356` | **Vector Icons Set (44 SVGs)** | طقم الأيقونات الفيكتور الكامل بدقة 24x24 بدون أي إيموجي أو نصوص مزيفة | `modules/gui/qt/resources/icons/` |
| `#244:184` | **Cone Volume Slider** | شريط الصوت الأيقوني المستوحى من قمع المرور الخاص بـ VLC | `modules/gui/qt/widgets/` |
| `#6065:13616` | **Context Menus** | القوائم السياقية العائمة الحديثة (Right-click, File, Folder, Playlist) | `modules/gui/qt/menus/qml/` |

---

## 🎯 3. منطق تجربة المستخدم المستخلص من شرح Jux (`transcript.md`)

1. **موضع زر التشغيل (The Hero Play Button):**
   - تم نقله إلى أقصى اليسار بحجم بارز (`44px`) مع زر الإيقاف المؤقت المدمج، بدلاً من التشتت في منتصف الشريط.
2. **الوصول المباشر لقوائم الصوت والترجمة (Direct Bottom-Right Access):**
   - أزرار مباشرة في الزاوية اليمنى تفتح القوائم المنبثقة لاختيار المسارات فوراً دون الحاجة للنقر بالزر الأيمن والتنقل في 4 قوائم متداخلة.
3. **الشريط الجانبي الموحد (Unified Quick Settings 380px):**
   - استبدال نافذة "صندوق باندورا" (Extended Settings) القديمة المعقدة بشريط جانبي أنيق ينساب من اليمين بتبويبات واضحة: الصوت، الفيديو، والتزامن اللحظي.
4. **المطابقة التلقائية للترجمات (Smart Subtitle Auto-Matching):**
   - الفحص التلقائي لمجلد الملف المشغل، استخراج رقم الموسم والحلقة (`S01E01`, `Ep 05`)، وربط ملف الترجمة المناسب تلقائياً بضغطة زر واحدة.
5. **شريط التقدم السميك والتفاعلي (Thick Scrub Bar):**
   - شريط بارز يتمدد عند التمرير، يعرض التوقيت اللحظي بدقة، مع علامات الفصول (Chapter Marks).
