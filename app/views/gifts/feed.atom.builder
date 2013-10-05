atom_feed language: 'en-US' do |feed|
  feed.title t(:title)
  feed.updated @updated

  @gifts.each do |gift|
    next if gift.updated_at.blank?

    feed.entry(gift) do |entry|
      entry.url gift_url(gift)
      entry.title gift.title
      entry.content gift.description, type: 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(gift.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

      entry.author do |author|
        author.name gift.user
      end

      #entry.link href: gift.preview.image_url(:medium).to_s, rel: 'enclosure', type: 'image/jpeg'

    end
  end
end
