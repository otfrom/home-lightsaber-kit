;; Everything will be configured using packages from melpa or
;; elsewhere. This is a minimal setup to get packages going.
(require 'package)
(setq package-archives '(("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("elpa" . "http://elpa.gnu.org/packages/")))

;; Pin to the stable version of cider
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(clj-refactor . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(cider-eval-sexp-fu . "melpa-stable") t)

;; This means we prefer things from ~/.emacs.d/elpa over the standard
;; packages.
(package-initialize)

;; This bootstraps us if we don't have anything
(when (not package-archive-contents)
  (package-refresh-contents))

;; We're going to try to declare the packages each feature needs as we
;; define it. To do this, we define a function `(package-require)`
;; which will fetch and install a package from the repositories if it
;; isn't already installed. Eg. to ensure the hypothetical package
;; `ponies` is installed, you'd call `(package-require 'ponies)`.
(defun package-require (pkg)
  "Install a package only if it's not already installed."
  (when (not (package-installed-p pkg))
    (package-install pkg)))

(dolist
    (p '(align-cljlet
         browse-kill-ring
         cider
         cider-eval-sexp-fu
         clj-refactor
         company
         dash
	 exec-path-from-shell
         highlight-symbol
         magit
         paredit
         projectile
         rainbow-delimiters
         toxi-theme))
  (package-require p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A little helper
(defun load-if-exists (file)
  (if (file-exists-p file)
      (progn
	(load file)
	(message (format "Loading file: %s" file)))
    (message (format "No %s file. So not loading one."
		     file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up things needed for clojure coding

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To put in your ~/.lein/profiles.clj
;; for clojure 1.6
;; {:user {:plugins [[cider/cider-nrepl "0.9.1"]
;;                   [refactor-nrepl "1.2.0-SNAPSHOT"]]
;;         :repl-options {:init (set! *print-length* 200)}}
;;
;; or for clojure 1.7 *only*
;; {:user {:plugins [[cider/cider-nrepl "0.10.0-SNAPSHOT"]
;;                   [refactor-nrepl "2.0.0-SNAPSHOT"]]
;;         :repl-options {:init (set! *print-length* 200)}}}

;; Show my parens
(show-paren-mode 1)

;; Don't trash the repl history
(setq cider-repl-history-file (concat user-emacs-directory "cider-history"))

;; Turn on company for completion everywhere
(global-company-mode)

;; Turn on projectile for completion everywhere
(projectile-global-mode)

;; CIDER configuration
;; Loads more information in the excellent README.md here:
;; https://github.com/clojure-emacs/cider

;; Add eldoc so we get function signatures in the minibuffer
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Add comments to the prompt for nice copy and pasting from the REPL
(setq cider-repl-result-prefix ";; => ")
(setq cider-interactive-eval-result-prefix ";; => ")

;; Make yourself into the person who likes paredit
(add-hook 'cider-repl-mode-hook #'paredit-mode)

;; See your delimiters more clearly
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

;; Highlight those evaluated sexps
(require 'cider-eval-sexp-fu)

;; tabs are evil
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elisp niceties
;; Make yourself into the person who likes paredit
(add-hook 'emacs-lisp-mode-hook #'paredit-mode)

;; See your delimiters more clearly
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make it pretty
(load-theme 'toxi 1)

(if (memq window-system '(mac ns))
    (set-default-font "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
  (set-default-font "Inconsolata-10"))

;; no toolbar
(tool-bar-mode -1)

;; no scroll bar
(scroll-bar-mode -1)

;; no horizontal scroll bar
(when (boundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

;; show line and column numbers
(line-number-mode 1)
(column-number-mode 1)

;; This really ought to be the default
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other useful defaults

;; keep autobackups under control
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

;; projectile everywhere
(projectile-global-mode)

;; put custom stuff in a different file
(setq custom-file "~/.emacs.d/local/custom.el")
(load-if-exists custom-file)

;; uniquify buffers with the same file name but different actual files
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;; Delete that horrible trailing whitespace
(add-hook 'before-save-hook
          (lambda nil
            (delete-trailing-whitespace)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Platform specific stuff

;; No # on UK Macs
(when (memq window-system '(mac ns))
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#"))))

;; Handle unicode better
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; get the path from shell
(when (memq window-system '(mac ns))
  (progn
    (require 'exec-path-from-shell)
    (exec-path-from-shell-initialize)))

;; fix yer speling
(when (memq window-system '(mac ns))
  (setq ispell-program-name (executable-find "aspell")))
