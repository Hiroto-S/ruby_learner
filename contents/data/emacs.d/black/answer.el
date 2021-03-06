(require 'package)
(add-to-list 'package-archives '("org" . "http:/orgmode.org/elpa/") t)
(add-to-list 'package-archives '("org-plus-contrib" . "https:/orgmode.org/elpa/contrib") t)

(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)

;; elファイルの置き場所を設定
(setq load-path (cons "~/.ruby_learner/.data/.emacs.d/inits" load-path))
(setq load-path (cons "~/.ruby_learner/.data/.emacs.d/ruby-mode" load-path))
(setq load-path (cons "~/.ruby_learner/.data/.emacs.d/org-mode" load-path))
(setq load-path (cons "~/.ruby_learner/.data/.emacs.d/themes" load-path))

;; 画面分割
(setq w (selected-window))
(setq w3 (split-window w nil t))
;; 画面移動
;; (setq windmove-wrap-around t)
(setq w2 (split-window w nil nil))
;; scratch文字
(setq initial-scratch-message "ctrl x & ctrl f 後に answer.rb を入力。")
(insert-file-contents "~/.ruby_learner/workshop/lib/answer.rb" nil 0 500)
(ruby-mode)
(find-file "~/.ruby_learner/workshop/lib/answer.rb")
;;setting_theme
(add-to-list 'custom-theme-load-path "~/.ruby_learner/.data/.emacs.d/themes")
(setq custom-theme-directory "~/.ruby_learner/.data/.emacs.d/themes")
(load-theme 'my-wombat t)

;; 起動時にスタートアップ画面を表示しない 
(setq inhibit-startup-message t)
;; 1 行ずつスムーズにスクロールする 
(setq scroll-step 1)
;; 行数を記載する
(global-linum-mode t)
(setq linum-format "%d")
(set-face-attribute 'linum nil
            :foreground "#999999"
            :background "#000000"
            :height 0.9)
(set-face-background 'default "#121212")
;; 文字色を設定
(set-face-foreground 'default "white")
;; 言語を日本語に設定
(set-language-environment 'Japanese)
;; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; エンコード方式をUTF-8に
(set-default-coding-systems 'utf-8)

(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(require 'ruby-mode)
(defun ruby-mode-set-encoding () nil)
;; 対応する括弧を光らせる
(show-paren-mode 1)
;; 最近使ったファイルの一覧
(recentf-mode 1)
;; タイトルバーに開いているバッファのパスを表示
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))
;; モードラインに時間を表示する
(display-time)
;; 現在の関数名をモードラインに表示
(which-function-mode 1)
;; 選択部分のインデント
(global-set-key "\C-x\C-i" 'indent-region)

;; ======================================================================
;;  Ruby mode
;; ======================================================================
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.ru$" . ruby-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.ru$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
            (inf-ruby-keys)))
(global-font-lock-mode 1)

;;;ruby-electric.el --- electric editing commands for ruby files
;;(require 'ruby-electric)
;;(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

;; ruby code folding from https://coderwall.com/p/u-l0ra/ruby-code-folding-in-emacs
(add-hook 'ruby-mode-hook
  (lambda () (hs-minor-mode)))

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
    `(ruby-mode
      ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
      ,(rx (or "}" "]" "end"))                       ; Block end
      ,(rx (or "#" "=begin"))                        ; Comment start
      ruby-forward-sexp nil)))

(global-set-key (kbd "C-c h") 'hs-hide-block)
(global-set-key (kbd "C-c s") 'hs-show-block)

;; =======================
;; org mode
;; =======================
(require 'ox-latex)
;; (require 'ox-bibtex) こいつは無くなったんかな．イランで．

;; org-modeで行末で折り返しをする
(setq org-startup-truncated nil)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
      '("article"
  "
  \\documentclass{jsarticle}
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[utf8]{inputenc}
  \\usepackage[T1]{fontenc}
  "
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}" . "\\paragraph*{%s}")
         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
        ))
 
;;; LaTeX 形式のファイル PDF に変換するためのコマンド
(setq org-latex-pdf-process
      '("platex %f"
        "bibtex %b"
        "platex %f"
        "platex %f"
        "dvipdfmx %b.dvi"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-latex-pdf-process
   (quote
    ("pdflatex -interaction nonstopmode -output-directory %o %f"
     "bibtex %o"
     "pdflatex -interaction nonstopmode -output-directory %o %f"
     "pdflatex -interaction nonstopmode -output-directory %o %f")))
 '(package-selected-packages (quote (haml-mode yaml-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
