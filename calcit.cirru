
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |phlox/ |touch-control/
      :type-slots $ {}
  :files $ {}
    'app.browser $ %{} 'FileEntry
      :defs $ {}
        'FontLoaderHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait FontLoaderHost
            .load $ :: 'Fn $ {}
              :args $ [] 'app.browser/FontLoaderHost
              :return 'js-ffi.shared/PromiseHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'wait-for-font! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn wait-for-font! (ready!)
            let
                loader $ js-cast (new FontFaceObserver "|Josefin Sans") 'app.browser/FontLoaderHost
                pending $ loader .load
              pending .then! $ fn (event) (ready!)
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.browser
          :require $ |fontfaceobserver-es :default FontFaceObserver
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                states $ :states store
                cursor $ []
                state $ match (get states :data)
                  (:none) spin-state
                  (:some value)
                    if (struct? value)
                      struct-match value (SpinState checked checked)
                        _ _ $ raise |Expected-SpinState
                      raise |Expected-SpinState
                bottom $ - (viewport-height) 40
                from $ :from state
                to $ :to state
                trails $ compute-trails state
              container
                {} $ :position $ []
                  - 0 $ * 0.5 $ viewport-width
                  - 0 $ * 0.5 $ viewport-height
                graphics $ {} $ :ops
                  concat
                    [] $ g :line-style $ {} (:width 1)
                      :color $ hslx 0 0 80
                      :alpha 1
                    -> trails rest $ mapcat $ fn (line)
                      []
                        g :move-to $ :start line
                        g :line-to $ :end line
                comp-drag-point (>> states :from)
                  {} (:position from) (:unit 1) (:title |From) (:radius 4)
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :from $ decode-map-as position (:: 'List 'Number)
                      , &unit
                comp-drag-point (>> states :to)
                  {} (:position to) (:unit 1) (:title |To) (:radius 4)
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :to $ decode-map-as position (:: 'List 'Number)
                      , &unit
                comp-slider (>> states :steps)
                  {}
                    :value $ :steps state
                    :title |steps
                    :position $ [] 40 bottom
                    :unit 1
                    :round? true
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :steps $ decode-map-as value Number
                      , &unit
                comp-slider (>> states :r1)
                  {}
                    :value $ :r1 state
                    :title |r1
                    :position $ [] 190 bottom
                    :unit 0.5
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :r1 $ decode-map-as value Number
                      , &unit
                comp-slider (>> states :r2)
                  {}
                    :value $ :r2 state
                    :title |r2
                    :unit 0.5
                    :position $ [] 340 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :r2 $ decode-map-as value Number
                      , &unit
                comp-slider (>> states :v1)
                  {}
                    :value $ :v1 state
                    :title |v1
                    :unit 0.001
                    :position $ [] 490 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :v1 $ decode-map-as value Number
                      , &unit
                comp-slider (>> states :v2)
                  {}
                    :value $ :v2 state
                    :title |v2
                    :unit 0.001
                    :position $ [] 640 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :v2 $ decode-map-as value Number
                      , &unit
                comp-slider (>> states :theta2)
                  {}
                    :value $ :theta2 state
                    :title |theta2
                    :unit 0.05
                    :position $ [] 790 bottom
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :theta2 $ decode-map-as value Number
                      , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'phlox.schema/PhloxElement)
            :args $ [] 'app.schema/Store
        'compute-trails $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn compute-trails (state)
            let
                from $ :from state
                to $ :to state
                steps $ :steps state
              if (<= steps 0) ([])
                let
                    unit $ complex/divide-by (complex/minus to from) steps
                  map (range steps)
                    fn (idx)
                      let
                          center $ complex/add from $ complex/times ([] idx 0) unit
                          theta-from $ * idx $ :v1 state
                          theta-end $ + (:theta2 state)
                            * idx $ :v2 state
                        Trail :start
                          complex/add center $ complex/times
                            [] (:r1 state) 0
                            [] (cos theta-from) (sin theta-from)
                          , :end $ complex/add center $ complex/times
                            [] (:r2 state) 0
                            [] (cos theta-end) (sin theta-end)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/SpinState
            :return $ :: 'List 'app.schema/Trail
          :tests $ [] $ %{} 'TestEntry (:name |geometry-and-zero-steps)
            :code $ quote $ let
                state $ app.schema/SpinState :from ([] 0 0) :to ([] 10 0) :steps 2 :r1 1 :r2 2 :theta2 0 :v1 0 :v2 0
              assert=
                []
                  app.schema/Trail :start ([] 1 0) :end $ [] 2 0
                  app.schema/Trail :start ([] 6 0) :end $ [] 7 0
                compute-trails state
              assert= ([])
                compute-trails $ assoc state :steps 0
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            phlox.core :refer $ defcomp >> hslx container graphics g
            phlox.comp.drag-point :refer $ comp-drag-point
            phlox.comp.slider :refer $ comp-slider
            app.schema :refer $ SpinState spin-state Trail
            js-ffi.browser :refer $ viewport-width viewport-height
            phlox.complex :as complex
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:dev-ui |http://localhost:8100/main-fonts.css) (:release-ui |http://cdn.tiye.me/favored-fonts/main-fonts.css) (:cdn-url |http://cdn.tiye.me/line-spin/) (:title "|Line Spin") (:icon |http://cdn.tiye.me/logo/quamolit.png) (:storage-key |line-spin)
          :examples $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store schema/store
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Store
        'decode-op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-op (raw-op)
            match raw-op
              (:states cursor data)
                schema/Op :states
                  decode-map-as cursor $ :: 'List 'Tag
                  , data
              (:add-x) (schema/Op :add-x)
              (:tab tab)
                schema/Op :tab $ decode-map-as tab 'Tag
              (:hydrate-storage restored)
                schema/Op :hydrate-storage $ if (struct? restored)
                  struct-match restored (schema/Store checked checked)
                    _ _ $ raise |Expected-Store
                  raise |Expected-Store
              _ $ raise |Unknown-operation
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Op)
            :args $ [] 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |anonymous-state-operation)
            :code $ quote $ let
                original schema/store
              assert=
                schema/Op :states ([] :r1)
                  {} $ :data 110
                decode-op $ :: :states ([] :r1)
                  {} $ :data 110
              match
                decode-op $ :: :hydrate-storage original
                (:hydrate-storage restored)
                  assert |Preserve-original-Store $ identical? original restored
                _ $ raise |Expected-hydrate-operation
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (raw-op)
            let
                op $ decode-op raw-op
              when dev? $ println |dispatch! op
              reset! *store $ updater @*store op
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            wait-for-font! render-app!
            add-watch! *store :change $ fn (store prev) (render-app!)
            render-control!
            start-control-loop! 8 on-control-event
            println "|App Started"
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (clear-phlox-caches!) (remove-watch! *store :change)
                add-watch! *store :change $ fn (store prev) (render-app!)
                render-app!
                replace-control-loop! 8 on-control-event
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! (comp-container @*store) dispatch! $ {}
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            phlox.core :refer $ render! clear-phlox-caches! on-control-event
            app.comp.container :refer $ comp-container
            app.schema :as schema
            phlox.config :refer $ dev?
            app.updater :refer $ updater
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
            app.browser :refer $ wait-for-font!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Tag) 'Dynamic
            :add-x
            :tab 'Tag
            :hydrate-storage 'app.schema/Store
          :examples $ []
          :schema $ :: 'EnumDef
        'SpinState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SpinState
            :from $ :: 'List 'Number
            :to $ :: 'List 'Number
            :steps 'Number
            :r1 'Number
            :r2 'Number
            :theta2 'Number
            :v1 'Number
            :v2 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:tab 'Tag) (:x 'Number)
            :states $ :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'StructDef
        'Trail $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Trail
            :start $ :: 'List 'Number
            :end $ :: 'List 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'spin-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def spin-state
            SpinState :from ([] 100 200) :to ([] 800 200) :steps 200 :r1 100 :r2 80 :theta2 100 :v1 0.18 :v2 1
          :examples $ []
          :schema $ :: 'app.schema/SpinState
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :tab :drafts :x 0 :states $ {}
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op)
            match op
              (:add-x)
                assoc store :x $ if
                  > (:x store) 10
                  , 0 $ inc (:x store)
              (:tab tab) (assoc store :tab tab)
              (:states cursor new-state)
                assoc store :states $ decode-map-as
                  assoc-in (:states store) (conj cursor :data) new-state
                  :: 'Map 'Tag 'Dynamic
              (:hydrate-storage restored) restored
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ app.schema :refer $ Store Op
