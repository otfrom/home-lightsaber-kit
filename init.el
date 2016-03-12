;;; init --- A home light saber kit

;; Copyright (C) 2016 Mastodon C Ltd

;;; Commentary:

;; Everything will be configured using packages from melpa or
;; elsewhere.  This is a minimal setup to get packages going.

;;; Code:

(require 'package)
(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-pinned-packages
      '((aggressive-indent . "melpa-stable")
        (bind-key . "melpa-stable")
        (cider . "melpa-stable")
        (cider-eval-sexp-fu . "melpa-stable")
	(clj-refactor . "melpa-stable")
        (clojure-mode . "melpa-stable")
        (company . "melpa-stable")
        ;; (dash . "melpa-stable")
        (diminish . "melpa-stable")
        (epl . "melpa-stable")
        (exec-path-from-shell . "melpa-stable")
        (flx . "melpa-stable")
        (flx-ido . "melpa-stable")
        (git-commit . "melpa-stable")
        (hydra . "melpa-stable")
        (ido . "melpa-stable")
        (ido-completing-read+ . "melpa-stable")
        (ido-ubiquitous . "melpa-stable")
        (ido-vertical-mode . "melpa-stable")
        (flycheck-pos-tip . "melpa-stable")
        (flycheck . "melpa-stable")
        (highlight . "melpa") ;; woo! from the wiki https://www.emacswiki.org/emacs/highlight.el
        (highlight-symbol . "melpa-stable")
        (inflections . "melpa-stable")
        (magit . "melpa-stable")
        (magit-popup . "melpa-stable")
        (multiple-cursors . "melpa-stable")
        (paredit . "melpa-stable")
        (peg . "melpa-stable")
        (pkg-info . "melpa-stable")
        (pos-tip . "melpa-stable")
        (projectile . "melpa-stable")
        (rainbow-delimiters . "melpa-stable")
        (s . "melpa-stable")
        (seq . "elpa")
        (smex . "melpa-stable")
        (swiper . "melpa-stable")
        (use-package . "melpa-stable")
        (with-editor . "melpa-stable")
        (yasnippet . "melpa-stable")))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; minor modes
(defvar lisp-mode-hooks '(emacs-lisp-mode-hook lisp-mode-hook clojure-mode-hook))
(defvar lisp-interaction-mode-hooks '(lisp-interaction-modes-hook cider-mode-hook cider-repl-mode-hook))

(defun bld/add-to-hooks (f hooks)
  "Add funcion F to all HOOKS."
  (dolist (hook hooks)
    (add-hook hook f)))

(use-package aggressive-indent
  :ensure t
  :diminish aggressive-indent-mode
  :config (bld/add-to-hooks #'aggressive-indent-mode lisp-mode-hooks))

(use-package eldoc
  :diminish eldoc-mode
  :config (bld/add-to-hooks #'eldoc-mode (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package paredit
  :ensure t
  :diminish paredit-mode
  :config (bld/add-to-hooks #'paredit-mode (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package flycheck-pos-tip
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package highlight-symbol
  :ensure t
  :diminish highlight-symbol
  :bind (("M-n" . highlight-symbol-next)
         ("M-p" . highlight-symbol-prev))
  :config (add-hook 'prog-mode-hook #'highlight-symbol-mode))

(use-package rainbow-delimiters
  :ensure t
  :diminish rainbow-delimiters
  :config (bld/add-to-hooks #'rainbow-delimiters-mode
                            (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package paren
  :config (bld/add-to-hooks #'show-paren-mode (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (setq projectile-enable-caching t)
  (projectile-global-mode 1))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (global-company-mode))

(use-package swiper
  :ensure t
  :bind (("\C-s" . swiper)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; major modes

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cider and clojure(script)

(use-package cider
  :ensure t
  :defer t
  :config
  (setq cider-repl-history-file (concat user-emacs-directory "cider-history")
	cider-font-lock-dynamically '(macro core function var)
	cider-repl-use-clojure-font-lock t
	cider-overlays-use-font-lock t
	cider-repl-result-prefix ";; => "
	cider-interactive-eval-result-prefix ";; => ")
  (cider-repl-toggle-pretty-printing))

(use-package clojure-mode
  :ensure t
  :defer t
  :mode (("\\.clj\\'" . clojure-mode)
	 ("\\.edn\\'" . clojure-mode)))

;; (use-package cider-eval-sexp-fu
;;   :ensure t)

(use-package clj-refactor
  :ensure t
  :defer t
  :config (add-hook 'cider-mode-hook #'clj-refactor-mode))

(use-package flycheck-clojure
  :ensure t
  :defer t
  :config
  (eval-after-load 'flycheck '(flycheck-clojure-setup)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ido and smex
(use-package smex
  :ensure t
  :bind (("M-x" . smex))
  :config (smex-initialize))  ; smart meta-x (use IDO in minibuffer)

(use-package ido
  :ensure t
  :demand t
  :bind (("C-x b" . ido-switch-buffer))
  :config (ido-mode 1)
  (setq ido-create-new-buffer 'always  ; don't confirm when creating new buffers
        ido-enable-flex-matching t     ; fuzzy matching
        ido-everywhere t  ; tbd
        ido-case-fold t)) ; ignore case

(use-package ido-ubiquitous
  :ensure t
  :config (ido-ubiquitous-mode 1))

(use-package flx-ido
  :ensure t
  :config (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure t
  :config (ido-vertical-mode 1))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other useful defaults

(global-set-key (kbd "C-;") 'comment-dwim)

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

;; downcase, upcase and narrow-to-region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; tab indentation (outside of makefiles) is evil
(setq-default indent-tabs-mode nil)

;; human readable dired
(setq dired-listing-switches "-alh")

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
  :init (exec-path-from-shell-initialize))

;; fix yer speling
(when (memq window-system '(mac ns))
  (setq ispell-program-name (executable-find "aspell")))

;; Handle unicode better
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;;; init.el ends here
