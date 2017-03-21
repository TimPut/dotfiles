;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("melpa" . "http://melpa.org/packages/")))

;(add-to-list 'package-archives
;             '("org" . "http://orgmode.org/elpa/")
;             '("melpa" . "http://melpa.org/packages/")
;             t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq package-list
  '(
    ;;intero ;;switched to dante.
    ac-ispell
    ac-math
    better-defaults
    company
    company-math
    company-quickhelp
    company-statistics
    dante
    diffview
    djvu
    ein
    elpy
    flycheck
    flyspell-correct-popup
    haskell-mode
    highlight-current-line
    highlight-indentation
    magit
    magit-popup
    magithub
    material-theme
    mmm-mode
    move-text
    multiple-cursors
    org
    org-beautify-theme
    org-bullets
    org-pdfview
    org-plus-contrib
    org-pomodoro
    org-ref
    org-time-budgets
    org-wc
    pdf-tools
    powerline
    py-autopep8
    pyvenv
    rainbow-delimiters
    rainbow-mode
    shm
    which-key
    ))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;(add-hook 'haskell-mode-hook 'intero-mode)
(add-hook 'haskell-mode-hook 'dante-mode)
(add-hook 'haskell-mode-hook 'flycheck-mode)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
;; enable line numbers in program major modes, global linum breaks PDFtools
(add-hook 'prog-mode-hook 'linum-mode)

;; enable rainbow delimiters in program major modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode-enable)

;; ;; PYTHON CONFIGURATION
;; ;; --------------------------------------

(elpy-enable)
(elpy-use-ipython)

;; ;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-ghc-show-info t)
 '(company-idle-delay 0)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote stack-ghci))
 '(haskell-tags-on-save t)
 '(highlight-current-line-globally nil nil (highlight-current-line))
 '(org-clock-out-when-done t)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-w3m org-bullets org-drill)))
 '(pdf-view-display-size (quote fit-width))
 '(pdf-view-use-imagemagick t))

;; Org-mode customization
;; ----------------------

;; Install org-drill from downloaded git repository
(add-to-list 'load-path "~/.emacs.d/pkgs/org-mode/contrib/lisp/")       
(require 'org-drill)

;; Turn on visual-line-mode for Org-mode only
;; Also consider installing "adaptive-wrap" from elpa
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)

;; Make org-mode time clock persistent across sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;;add todo list states for org-mode
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING-ON" "|" "DONE" "CANCELLED")))

;; Org-mode link insertion keybinding
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)

;; Enable autosaved sessions
(desktop-save-mode 1)

;; Disable org-mode priorities
(setq org-enable-priority-commands nil)

;; Start emacs as a server when called from emacsclient
(server-start)

; Make Emacs look in Cabal directory for binaries
(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

; HASKELL-MODE
; ------------

; Choose indentation mode
;; Use haskell-mode indentation
;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; Use hi2
;(require 'hi2)
;(add-hook 'haskell-mode-hook 'turn-on-hi2)
;; Use structured-haskell-mode
(add-hook 'haskell-mode-hook 'structured-haskell-mode)

; Add F8 key combination for going to imports block
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))

; Add key combinations for interactive haskell-mode
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))
(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
(eval-after-load 'haskell-cabal
  '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))

(setq haskell-process-type 'stack-ghci)
(setq inferior-haskell-find-project-root nil)

;; GHC-MOD
;; -------

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; COMPANY-GHC
;; -----------

; Enable company-mode
(require 'company)
; Use company in Haskell buffers
; (add-hook 'haskell-mode-hook 'company-mode)
; Use company in all buffers
(add-hook 'after-init-hook 'global-company-mode)

(add-to-list 'company-backends 'company-ghc)

;; Convenience Functions:

(defun google (string)
  "Run a Google search in a browser."
  (interactive "sSearch for: ")
  (browse-url (concat "http://www.google.com/search?q=" string)))

(defun google-region (from to &optional quoted)
  "Run a Google search on the contents of the region FROM/TO"
  (interactive "r\nP")
  ;; (message "google-region %d %d %s" from to quoted)
  (let ((str (buffer-substring from to)))
    (google (if quoted (concat "\"" str "\"") str))
    ))
(global-set-key (kbd "C-c g") 'google-region)


;; ERC Customization
;; -----------------
 '(erc-autojoin-channels-alist
   (quote
    (("freenode.net" "#haskell-blah" "#haskell-iphone" "#haskell-ops" "#haskell-in-depth" "#ghc" "#haskell")
     (".*\\.freenode\\.net" "#haskell" "#ghc" "#haskell-in-depth" "#haskell-ops" "#haskell-blah" "#haskell-iphone"))))
 '(erc-away-nickname nil)
 '(erc-fill-column 100)
 '(erc-fill-mode nil)
 '(erc-nick "tput")
 '(erc-nick-uniquifier "-")
 '(erc-prompt-for-password f)
 '(erc-user-full-name "Tim Put")
 '(erc-whowas-on-nosuchnick t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
