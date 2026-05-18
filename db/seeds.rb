exit unless Rails.env.development?

User.destroy_all

nomads = [
  {
    name: "Carlos Mendoza",
    email: "carlos@example.com",
    password: "password123",
    country: "México",
    profession: "Desarrollador Full Stack",
    bio: "Soy desarrollador con 8 años de experiencia en Rails y React. Trabajo desde cualquier rincón del mundo, me especializo en startups y productos SaaS. Siempre abierto a colaboraciones y proyectos desafiantes.",
    whatsapp: "+521234567890",
    published: true
  },
  {
    name: "Ana García",
    email: "ana@example.com",
    password: "password123",
    country: "España",
    profession: "Diseñadora UX/UI",
    bio: "Diseñadora apasionada por crear experiencias digitales únicas. He trabajado con startups en Madrid, Berlín y Ciudad de México. Actualmente trabajo desde Bali mientras inspecciono nuevos horizontes.",
    whatsapp: "+34612345678",
    published: true
  },
  {
    name: "Mateo Rossi",
    email: "mateo@example.com",
    password: "password123",
    country: "Argentina",
    profession: "Consultor de Marketing Digital",
    bio: "Especialista en growth hacking y estrategias digitales. Ayudo a empresas a crecer su presencia online desde cualquier parte del mundo. Fanático del café y los nuevos destinos.",
    whatsapp: "+5491112345678",
    published: true
  },
  {
    name: "Sofía Alves",
    email: "sofia@example.com",
    password: "password123",
    country: "Brasil",
    profession: "Desarrolladora Mobile",
    bio: "Desarrolladora iOS y Android con 5 años de experiencia. Apasionada por crear apps que transformen la vida de las personas. Nómada digital desde 2022, actualmente en Portugal.",
    whatsapp: "+5511987654321",
    published: true
  },
  {
    name: "Diego Fuentes",
    email: "diego@example.com",
    password: "password123",
    country: "Colombia",
    profession: "Fotógrafo y Videógrafo",
    bio: "Capturo historias a través de mi lente desde más de 40 países. Especializado en contenido para marcas, viajes y lifestyle. Disponible para proyectos remotos y colaboraciones internacionales.",
    whatsapp: "+573001234567",
    published: true
  },
  {
    name: "Laura Kimura",
    email: "laura@example.com",
    password: "password123",
    country: "Japón",
    profession: "Traductora e Intérprete",
    bio: "Traductora certificada en japonés, inglés y español. Especializada en documentos legales, técnicos y contenido creativo. Vivo nómada entre Tokio, Barcelona y Buenos Aires.",
    whatsapp: "+819012345678",
    published: true
  }
]

nomads.each do |attrs|
  User.create!(attrs)
  print "."
end

puts "\n✅ #{User.count} nómadas creados correctamente."
