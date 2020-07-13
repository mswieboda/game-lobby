require './config/environment'
require './models/application_record'
require './models/lobby'
require 'json'

class App < Roda
  route do |r|
    r.on "lobbies" do
      # GET /lobbies/5
      r.on Integer do |lobby_id|
        lobby = Lobby.find(lobby_id)

        # POST /lobbies/5/join
        r.post "join" do
          lobby.update!(peers: lobby.peers + 1)
          lobby.to_json
        end

        # POST /lobbies/5/leave
        r.post "leave" do
          lobby.update!(peers: lobby.peers - 1)
          lobby.to_json
        end

        r.is do
          r.get do
            lobby.to_json
          end
        end
      end

      # GET /lobbies
      r.is do
        r.get do
          Lobby.all.to_a.to_json
        end
      end
    end
  end
end
