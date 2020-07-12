require "roda"
require "json"

class App < Roda
  route do |r|
    r.on "lobbies" do
      # GET /lobbies
      r.get do
        [{ip: "123.168.1.1", name: "foo", status: "open", peers: 5, max_peers: 10}].to_json
      end

      # GET /lobbies/5
      r.on Integer do |lobby_id|
        r.get do
          {ip: "123.168.1.1", name: "foo", status: "open", peers: 5, max_peers: 10}.to_json
        end

        # POST /lobbies/5/join
        r.post "join" do
          {ip: "123.168.1.1", name: "foo", status: "open", peers: 6, max_peers: 10}.to_json
        end

        # POST /lobbies/5/leave
        r.post "leave" do
          {ip: "123.168.1.1", name: "foo", status: "open", peers: 5, max_peers: 10}.to_json
        end
      end
    end
  end
end

run App.freeze.app
