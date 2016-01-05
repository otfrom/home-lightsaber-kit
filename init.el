;; Everything will be configured using packages from melpa or
;; elsewhere. This is a minimal setup to get packages going.
(require 'package)
(setq package-archives '(("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                         ("elpa" . "http://elpa.gnu.org/packages/")))

;; This means we prefer things from ~/.emacs.d/elpa over the standard
;; packages.
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(defvar use-package-verbose t)
(require 'bind-key)
(require 'diminish)

(use-package magit
             :ensure t)
