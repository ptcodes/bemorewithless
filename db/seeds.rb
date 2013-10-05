# encoding: utf-8

puts 'Creating categories...'
[
  ['Autos, bicicletas y partes', 'Cars, bikes & parts'],
  ['Salud y Belleza', 'Health & beauty'],
  ['Bolsos, bisutería y accesorios', 'Handbags, jewelery & accessories'],
  ['Moda y vestuario', 'Fashion & clothing'],
  ['Embarazo, bebés y niños', 'Pregnancy, babies & children'],
  ['Música', 'Music'],
  ['Arte, antigüedades y coleccione', 'Art, antiques & collectibles'],
  ['Computadores y Accesorios', 'Computers & accessories'],
  ['Celulares y teléfonos', 'Phones & accessories'],
  ['Jardín y herramientas', 'Garden & tools'],
  ['Muebles y artículos del hogar', 'Furniture & household items'],
  ['Animales y sus accesorios', 'Animals & accessories'],
  ['Libros y Revistas', 'Books & magazines'],
  ['Consolas y videojuegos', 'Consoles & video games'],
  ['Películas', 'Movies'],
  ['Deportes', 'Sport'],
  ['Audio, TV, video y fotografía', 'Audio, TV, video & photo'],
  ['Otros', 'Other']
].each do |name|
  I18n.locale = :es
  category = Category.new(name: name.first)
  I18n.locale = :en
  category.name = name.last
  category.save!
end

puts 'Creating deliveries...'
[
  ['Encuentro personal', 'Personal meeting'],
  ['Reunion grupal', 'Group meeting'],
  ['Lugar de entrega', 'Pickup'],
  ['Servicio de correo', 'Post service']
].each do |name|
  I18n.locale = :es
  delivery = Delivery.new(name: name.first)
  I18n.locale = :en
  delivery.name = name.last
  delivery.save!
end
