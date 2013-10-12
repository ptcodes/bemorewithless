# encoding: utf-8

if (Category.count > 0)
  puts 'Skip creating categories. Count > 0'
else
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
end

if (Delivery.count > 0)
  puts 'Skip creating deliveries. Count > 0'
else
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
end

require "random_data"
require "ap"

if (User.count > 0)
  puts 'Skip creating users. Count > 0'
else
if Rails.env.test? || Rails.env.development?
  puts 'Creating users'

  count = 3
  ind = 0
  count.times{
    ind += 1
    puts "#{ind} / #{count}"
    user = User.new
    user[:uid] = Random.number(100000000000)
    user[:first_name] = Random.firstname
    user[:last_name] = Random.lastname
    user[:username] = "#{user[:first_name]}.#{user[:last_name]}.#{Random.number(999)}"

    user[:provider] = "facebook"
    user[:language] = "en"

    user[:created_at] = Random.date
    user[:updated_at] = user[:created_at]

    user[:email] = Random.email

    user.password = Random.alphanumeric(10)
    user.encrypted_password = user.password
    #puts "\n#{user.inspect}\n\n"
    #puts "\n#{user.to_yaml}\n\n"
    #ap user
    user.save!
  }

  puts "USERS:\n"
  users = User.all
  ap users
end
end
