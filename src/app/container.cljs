
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp >> hslx rect circle text container graphics create-list g]]
            [phlox.comp.drag-point :refer [comp-drag-point]]
            [phlox.complex :as complex]
            [phlox.comp.slider :refer [comp-slider]]))

(defcomp
 comp-container
 (store)
 (let [states (:states store)
       cursor []
       state (or (:data states)
                 {:from [100 200],
                  :to [800 200],
                  :steps 200,
                  :r1 100,
                  :r2 80,
                  :theta2 100,
                  :v1 0.18})
       bottom (- js/window.innerHeight 40)
       r1 (:r1 state)
       r2 (:r2 state)
       v1 (:v1 state)
       v2 (:v2 state)
       theta2 (:theta2 state)
       from (:from state)
       to (:to state)
       steps (:steps state)
       unit (complex/divide-by (complex/minus to from) steps)
       trails (->> (range steps)
                   (map
                    (fn [idx]
                      (let [center (complex/add from (complex/times [idx 0] unit))
                            theta-from (* idx v1)
                            theta-end (+ theta2 (* idx v2))]
                        {:start (complex/add
                                 center
                                 (complex/times
                                  [r1 0]
                                  [(js/Math.cos theta-from) (js/Math.sin theta-from)])),
                         :end (complex/add
                               center
                               (complex/times
                                [r2 0]
                                [(js/Math.cos theta-end) (js/Math.sin theta-end)]))}))))]
   (container
    {}
    (graphics
     {:ops (concat
            [(g :line-style {:width 1, :color (hslx 0 0 80), :alpha 1})]
            (->> trails
                 rest
                 (mapcat (fn [line] [(g :move-to (:start line)) (g :line-to (:end line))]))))})
    (comp-drag-point
     (>> states :from)
     {:position from,
      :unit 1,
      :title "From",
      :radius 4,
      :on-change (fn [position d!] (d! cursor (assoc state :from position)))})
    (comp-drag-point
     (>> states :to)
     {:position to,
      :unit 1,
      :title "To",
      :radius 4,
      :on-change (fn [position d!] (d! cursor (assoc state :to position)))})
    (comp-slider
     (>> states :steps)
     {:value (:steps state),
      :title "steps",
      :position [40 bottom],
      :unit 1,
      :round? true,
      :on-change (fn [value d!] (d! cursor (assoc state :steps value)))})
    (comp-slider
     (>> states :r1)
     {:value (:r1 state),
      :title "r1",
      :position [190 bottom],
      :unit 0.5,
      :on-change (fn [value d!] (d! cursor (assoc state :r1 value)))})
    (comp-slider
     (>> states :r2)
     {:value (:r2 state),
      :title "r2",
      :unit 0.5,
      :position [340 bottom],
      :on-change (fn [value d!] (d! cursor (assoc state :r2 value)))})
    (comp-slider
     (>> states :v1)
     {:value (:v1 state),
      :title "v1",
      :unit 0.001,
      :position [490 bottom],
      :on-change (fn [value d!] (d! cursor (assoc state :v1 value)))})
    (comp-slider
     (>> states :v2)
     {:value (:v2 state),
      :title "v2",
      :unit 0.001,
      :position [640 bottom],
      :on-change (fn [value d!] (d! cursor (assoc state :v2 value)))})
    (comp-slider
     (>> states :theta2)
     {:value (:theta2 state),
      :title "theta2",
      :unit 0.05,
      :position [790 bottom],
      :on-change (fn [value d!] (d! cursor (assoc state :theta2 value)))}))))
