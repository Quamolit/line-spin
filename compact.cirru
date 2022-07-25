
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.0)
    :modules $ [] |memof/ |lilac/ |respo.calcit/ |respo-ui.calcit/ |phlox/ |touch-control/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (store)
            let
                states $ :states store
                cursor $ []
                state $ or (:data states)
                  {}
                    :from $ [] 100 200
                    :to $ [] 800 200
                    :steps 200
                    :r1 100
                    :r2 80
                    :theta2 100
                    :v1 0.18
                bottom $ - js/window.innerHeight 40
                r1 $ :r1 state
                r2 $ :r2 state
                v1 $ :v1 state
                v2 $ :v2 state
                theta2 $ :theta2 state
                from $ :from state
                to $ :to state
                steps $ :steps state
                unit $ complex/divide-by (complex/minus to from) steps
                trails $ -> (range steps)
                  map $ fn (idx)
                    let
                        center $ complex/add from
                          complex/times ([] idx 0) unit
                        theta-from $ * idx v1
                        theta-end $ + theta2 (* idx v2)
                      {}
                        :start $ complex/add center
                          complex/times ([] r1 0)
                            [] (js/Math.cos theta-from) (js/Math.sin theta-from)
                        :end $ complex/add center
                          complex/times ([] r2 0)
                            [] (js/Math.cos theta-end) (js/Math.sin theta-end)
              container ({})
                graphics $ {}
                  :ops $ concat
                    [] $ g :line-style
                      {} (:width 1)
                        :color $ hslx 0 0 80
                        :alpha 1
                    -> trails rest $ mapcat
                      fn (line)
                        []
                          g :move-to $ :start line
                          g :line-to $ :end line
                comp-drag-point (>> states :from)
                  {} (:position from) (:unit 1) (:title "\"From") (:radius 4)
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :from position
                comp-drag-point (>> states :to)
                  {} (:position to) (:unit 1) (:title "\"To") (:radius 4)
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :to position
                comp-slider (>> states :steps)
                  {}
                    :value $ :steps state
                    :title "\"steps"
                    :position $ [] 40 bottom
                    :unit 1
                    :round? true
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :steps value
                comp-slider (>> states :r1)
                  {}
                    :value $ :r1 state
                    :title "\"r1"
                    :position $ [] 190 bottom
                    :unit 0.5
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :r1 value
                comp-slider (>> states :r2)
                  {}
                    :value $ :r2 state
                    :title "\"r2"
                    :unit 0.5
                    :position $ [] 340 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :r2 value
                comp-slider (>> states :v1)
                  {}
                    :value $ :v1 state
                    :title "\"v1"
                    :unit 0.001
                    :position $ [] 490 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :v1 value
                comp-slider (>> states :v2)
                  {}
                    :value $ :v2 state
                    :title "\"v2"
                    :unit 0.001
                    :position $ [] 640 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :v2 value
                comp-slider (>> states :theta2)
                  {}
                    :value $ :theta2 state
                    :title "\"theta2"
                    :unit 0.05
                    :position $ [] 790 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :theta2 value
      :ns $ quote
        ns app.comp.container $ :require
          [] phlox.core :refer $ [] defcomp >> hslx rect circle text container graphics create-list g
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
          [] phlox.complex :as complex
          [] phlox.comp.slider :refer $ [] comp-slider
    |app.config $ {}
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ quote
          def site $ {} (:dev-ui "\"http://localhost:8100/main-fonts.css") (:release-ui "\"http://cdn.tiye.me/favored-fonts/main-fonts.css") (:cdn-url "\"http://cdn.tiye.me/line-spin/") (:title "\"Line Spin") (:icon "\"http://cdn.tiye.me/logo/quamolit.png") (:storage-key "\"line-spin")
      :ns $ quote (ns app.config)
    |app.main $ {}
      :defs $ {}
        |*store $ quote (defatom *store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and dev? $ not= op :states
              println "\"dispatch!" op op-data
            let
                op-id $ nanoid
                op-time $ js/Date.now
              reset! *store $ updater @*store op op-data op-id op-time
        |main! $ quote
          defn main! () (; js/console.log PIXI)
            if dev? $ load-console-formatter!
            -> (new FontFaceObserver "\"Josefin Sans") (.!load)
              .!then $ fn (event) (render-app!)
            add-watch *store :change $ fn (store prev) (render-app!)
            render-control!
            start-control-loop! 8 on-control-event
            println "\"App Started"
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (clear-phlox-caches!) (remove-watch *store :change)
              add-watch *store :change $ fn (store prev) (render-app!)
              render-app!
              replace-control-loop! 8 on-control-event
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |render-app! $ quote
          defn render-app! (? arg)
            render! (comp-container @*store) dispatch! $ or arg ({})
      :ns $ quote
        ns app.main $ :require ("\"pixi.js" :as PIXI)
          phlox.core :refer $ render! clear-phlox-caches! update-viewer! on-control-event
          app.comp.container :refer $ comp-container
          app.schema :as schema
          phlox.config :refer $ dev? mobile?
          "\"nanoid" :refer $ nanoid
          app.updater :refer $ updater
          "\"fontfaceobserver-es" :default FontFaceObserver
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
          touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
    |app.schema $ {}
      :defs $ {}
        |store $ quote
          def store $ {} (:tab :drafts) (:x 0)
            :states $ {}
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"unknown op" op op-data) store
              :add-x $ update store :x
                fn (x)
                  if (> x 10) 0 $ + x 1
              :tab $ assoc store :tab op-data
              :states $ let-sugar
                    [] cursor new-state
                    , op-data
                assoc-in store
                  concat ([] :states) cursor $ [] :data
                  , new-state
              :hydrate-storage op-data
      :ns $ quote (ns app.updater)
