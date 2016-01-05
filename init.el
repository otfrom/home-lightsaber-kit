;; Everything will be configured using packages from melpa or
;; elsewhere. This is a minimal setup to get packages going.
(require 'package)
(setq package-archives '(("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")
			 ("elpa" . "http://elpa.gnu.org/packages/")))

;; This means we prefer things from ~/.emacs.d/elpa over the standard
;; packages.
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(defvar use-package-verbose t)
(require 'bind-key)
(require 'diminish)

(use-package emacs-lisp
  :init
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode))

(use-package magit
  :ensure t
  :pin melpa-stable)

(use-package projectile
  :ensure t
  :pin melpa-stable
  :init
  (setq projectile-enable-caching t)
  :diminish projectile-mode
  :config
  (projectile-global-mode 1))

(use-package company
  :ensure t
  :pin melpa-stable
  :diminish company-mode
  :config
  (global-company-mode))

(use-package highlight-symbol
  :ensure t
  :pin melpa-stable
  :defer t)

(use-package paredit
  :ensure t
  :pin melpa-stable
  :defer t
  :diminish paredit-mode)

(use-package eldoc
  :diminish eldoc-mode)

(use-package rainbow-delimiters
  :ensure t
  :pin melpa-stable
  :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display Tweaking
(load-theme 'wheatgrass)

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

;; put custom stuff in a different file
(setq custom-file (concat user-emacs-directory "custom.el"))

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
(use-package exec-path-from-shell
  :ensure t
  :defer t
  :pin melpa-stable
  :config (exec-path-from-shell-initialize))

;; fix yer speling
(when (memq window-system '(mac ns))
  (setq ispell-program-name (executable-find "aspell")))

;; Handle unicode better
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
