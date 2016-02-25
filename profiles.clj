{:user {:plugins [[cider/cider-nrepl "0.10.2"]
                  [refactor-nrepl "2.0.0"]]
        :dependencies [[org.clojure/tools.nrepl "0.2.12"]
                       [acyclic/squiggly-clojure "0.1.4"]]
        :repl-options {:init (set! *print-length* 200)}}}
