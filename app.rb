require './config/environment'
require './models/application_record'
require './models/lobby'
require 'json'

class App < Roda
  plugin :all_verbs

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

        # DELETE /lobbies/5/leave
        r.delete "leave" do
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
