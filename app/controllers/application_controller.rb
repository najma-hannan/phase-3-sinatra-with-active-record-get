class ApplicationController < Sinatra::Base
  set :default_content_type, "application/json"
  get '/' do
    { message: "Hello world" }.to_json
  end

  get "/games" do
    games = Game.all.limit(10)
    games.to_json
  end

  get "/games/:id" do
    game = Game.find(params[:id])
    # game.to_json(include: :reviews) # -> include the revies tied to every game
    # game.to_json(include: { reviews: { include: :user } }) # -> include the user tied to every review for a particular game
    game.to_json(
      only: %i[id title genre price],
      include: {
        reviews: {
          only: %i[comment score],
          include: {
            user: {
              only: [:name]
            }
          }
        }
      }
    ) # -> include only specific fields from the main response as well as for the reviews and the users
  end

end
