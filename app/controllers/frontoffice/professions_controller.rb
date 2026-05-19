class Frontoffice::ProfessionsController < Frontoffice::BaseController
  PROFESSIONS = [
    {
      slug: "full-stack-developer",
      icon: "bi-layers-fill",
      color: "#3d7a55",
      name: "Full Stack Developer",
      tagline: "Builds complete web products from scratch.",
      description: "A Full Stack Developer can build an entire web product on their own — from what you see on screen to the database and logic running in the background. They handle the whole picture.",
      services: ["Custom websites and web platforms", "Online stores (e-commerce)", "Management systems and dashboards", "Internal tools and admin panels", "APIs and backend services"]
    },
    {
      slug: "frontend-developer",
      icon: "bi-window-fullscreen",
      color: "#2277c4",
      name: "Frontend Developer",
      tagline: "Creates everything you see and interact with on a website.",
      description: "A Frontend Developer turns designs into real, working screens. They make sure your site looks polished, loads quickly, and works perfectly on phones and computers alike.",
      services: ["Responsive websites (mobile + desktop)", "Landing pages and sales pages", "Interactive dashboards", "Animations and visual effects", "Improving the look of existing sites"]
    },
    {
      slug: "backend-developer",
      icon: "bi-server",
      color: "#6d4aab",
      name: "Backend Developer",
      tagline: "Builds the brain and engine behind your website or app.",
      description: "A Backend Developer handles everything users don't see: databases, servers, security, payments, and all the logic that makes your product actually work. If your app does something, they built how it does it.",
      services: ["User login and accounts system", "Payment processing integration", "Database design and management", "API connections with third-party services", "Automations and scheduled tasks"]
    },
    {
      slug: "mobile-developer",
      icon: "bi-phone-fill",
      color: "#c0392b",
      name: "Mobile Developer",
      tagline: "Builds apps for phones and tablets.",
      description: "A Mobile Developer creates applications that run on smartphones. Whether you need an Android app, an iOS app, or one that works on both, they turn your idea into something people can install from the app store.",
      services: ["Android and iOS apps", "Apps that work on both platforms", "Push notifications", "App store publishing (Google Play / App Store)", "Integration with phone features (camera, GPS, etc.)"]
    },
    {
      slug: "ui-ux-designer",
      icon: "bi-palette-fill",
      color: "#e67e22",
      name: "UI/UX Designer",
      tagline: "Designs how apps and websites look and feel to use.",
      description: "A UI/UX Designer focuses on making your product easy and pleasant to use. They research what users need, sketch how screens should flow, and create the final visual design before a developer builds it.",
      services: ["App and website design (mockups)", "User experience research", "Interactive prototypes", "Improving confusing interfaces", "Brand style guides and design systems"]
    },
    {
      slug: "graphic-designer",
      icon: "bi-brush-fill",
      color: "#d81b60",
      name: "Graphic Designer",
      tagline: "Creates visual content for your brand and marketing.",
      description: "A Graphic Designer creates the visual identity of your business — logos, banners, social media posts, packaging, and anything that needs to look professional and on-brand.",
      services: ["Logo and brand identity", "Social media graphics", "Flyers, posters and print material", "Presentations and pitch decks", "Packaging and merchandise design"]
    },
    {
      slug: "data-analyst",
      icon: "bi-graph-up-arrow",
      color: "#00838f",
      name: "Data Analyst",
      tagline: "Turns your business data into useful insights.",
      description: "A Data Analyst looks at the numbers and patterns in your business and tells you what they mean. They help you make smarter decisions by showing you what's working, what's not, and what to focus on.",
      services: ["Sales and revenue reports", "Customer behavior analysis", "Interactive charts and dashboards", "Forecasts and trend projections", "Cleaning and organizing messy data"]
    },
    {
      slug: "digital-marketer",
      icon: "bi-megaphone-fill",
      color: "#1565c0",
      name: "Digital Marketer",
      tagline: "Grows your brand's presence and sales online.",
      description: "A Digital Marketer helps people find your business on the internet. They run ads, manage social media, improve your Google ranking, and build campaigns that attract customers and convert them.",
      services: ["Social media management", "Google and Meta ad campaigns", "SEO (appearing in Google searches)", "Email marketing campaigns", "Content strategy and planning"]
    },
    {
      slug: "copywriter",
      icon: "bi-pen-fill",
      color: "#5d4037",
      name: "Copywriter",
      tagline: "Writes words that sell, inform, and connect with people.",
      description: "A Copywriter crafts the text that represents your business — from your website's homepage to ads, emails, and social posts. Good copy makes people understand what you offer and want to buy it.",
      services: ["Website copy (homepage, about, services)", "Ad scripts and promotional text", "Email sequences", "Blog articles and SEO content", "Product descriptions"]
    },
    {
      slug: "video-editor",
      icon: "bi-camera-video-fill",
      color: "#c62828",
      name: "Video Editor",
      tagline: "Turns raw footage into polished, engaging video content.",
      description: "A Video Editor takes your recorded footage (or stock clips) and assembles it into a professional video — with music, text, transitions, and effects. They turn rough recordings into content people actually watch.",
      services: ["YouTube and social media videos", "Product demo and explainer videos", "Reels and short-form content", "Event and highlight videos", "Video ads for campaigns"]
    },
    {
      slug: "project-manager",
      icon: "bi-kanban-fill",
      color: "#37474f",
      name: "Project Manager",
      tagline: "Organizes teams and makes sure projects get delivered on time.",
      description: "A Project Manager keeps everything on track. They coordinate between designers, developers, and clients, set timelines, remove blockers, and make sure your project is delivered on time and within budget.",
      services: ["Project planning and roadmaps", "Team coordination and communication", "Risk identification and management", "Budget tracking", "Agile / Scrum facilitation"]
    },
    {
      slug: "devops-engineer",
      icon: "bi-cloud-check-fill",
      color: "#2e7d32",
      name: "DevOps Engineer",
      tagline: "Keeps your servers running fast, stable, and secure.",
      description: "A DevOps Engineer manages the infrastructure that hosts your website or app. They set up servers, automate deployments, handle backups, and make sure your product is online 24/7 without crashing.",
      services: ["Server setup and configuration", "Automatic deployment pipelines", "Monitoring and alerts", "Database backups and recovery", "Performance and cost optimization"]
    }
  ].freeze

  def index
    @professions = PROFESSIONS
  end
end
