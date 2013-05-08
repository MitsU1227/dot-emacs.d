;; ---------------------------------------------------------------------------------
;;; @ general setting

;; common lisp
(eval-when-compile (require 'cl))

;; 文字コードの設定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; commandをmeta, altをsuperに設定する
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; スタートアップ, ツールバー, メニューバー, スクロールバーを非表示にする
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; タイトルバーにファイルのフルパスを表示する
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; 行番号を表示する
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)
(setq linum-format "%4d") ; 行番号のフォーマットを設定する

;; モードラインに行, 列番号, バッテリー残量を表示する
(line-number-mode t)
(column-number-mode t)
(display-battery-mode t)

;; 括弧の範囲内を強調表示する
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face "#3F3F3F")

;; 選択領域の色設定
(set-face-background 'region "#0000FF")

;; 行間の設定
(setq-default line-spacing 0)

;; 1行ずつスクロールさせる
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t)

;; トラックパッドのスクロール設定
(defun scroll-down-with-lines ()
  "" (interactive) (scroll-down 3)) ; 1回でスクロールする行数
(defun scroll-up-with-lines ()
  "" (interactive) (scroll-up 3))
(global-set-key [wheel-up] 'scroll-down-with-lines)
(global-set-key [wheel-down] 'scroll-up-with-lines)
(global-set-key [double-wheel-up] 'scroll-down-with-lines)
(global-set-key [double-wheel-down] 'scroll-up-with-lines)
(global-set-key [triple-wheel-up] 'scroll-down-with-lines)
(global-set-key [triple-wheel-down] 'scroll-up-with-lines)

;; 背景, 文字, カーソルの色設定
(custom-set-faces
 '(default ((t (:background "#000000" :foreground "FFFFFF"))))
 '(cursor (
           (((class color) (background dark )) (:background "#7F7F7F"))
           (((class color) (background light)) (:background "#7F7F7F"))
           (t ())
           )))

;; フレームの設定
(setq default-frame-alist
      (append (list 
	'(width . 179) ; フレームの幅
	'(height . 53) ; フレームの高さ
	'(alpha . (80 80)) ; フレームの透明度
	)
	default-frame-alist))

;; ビープ音をならさない
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; scratchの初期メッセージを消去する
(setq initial-scratch-message "")

;; バックアップを残さない
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

;; ファイル内のカーソル位置を記憶する
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/cache/saveplace/.emacs-places") ; 保存する場所

;; 履歴の保存設定
(require 'savehist) ; ミニバッファの履歴を保存する
(savehist-mode 1)
(setq history-length 1000) ; 保存数
(require 'recentf) ; 最近開いたファイルの履歴を保存する
(recentf-mode 1)
(setq recentf-max-menu-items 20)   ; 表示数
(setq recentf-max-saved-items 100) ; 保存数

;; 履歴を保存する場所を設定する
(setq savehist-file "~/.emacs.d/cache/savehist/history") ; savehist
(custom-set-variables
 '(recentf-save-file
   (format "~/.emacs.d/cache/recentf/%s"
           (replace-regexp-in-string "\\." "_" system-configuration)))) ; recentf

;; メッセージバッファに保存される最大行数
(setq message-log-max 10000)

;; ミニバッファで入力を取り消しても履歴に残るようにする
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; ミニバッファを再帰的に呼び出せるようにする
(setq enable-recursive-minibuffers t)

;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)

;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold)) ; defaultは*1

;; 大きいファイルを開こうとした時に警告する
(setq large-file-warning-threshold (* 20 1024 1024)) ; defaultは*10

;; yes-or-noをy-or-nとする
(defalias 'yes-or-no-p 'y-or-n-p)

;; Emacs Lisp Package Archive - ELPAの設定
(require 'package)
(add-to-list
 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list
 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; C-zで中断されるのを無効化する
(global-unset-key "\C-z")

;; C-RETで矩形選択モードに切り替える
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; toggle-truncate-linesキーで, 行の見えない部分を折り返すかどうかを切り替える
(defun toggle-truncate-lines ()
  "折り返し表示をトグル動作します."
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))



;; ---------------------------------------------------------------------------------
;;; @ path setting

;; exec-pathの設定
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/usr/local/bin")

;; load-path を追加する関数を定義する
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加する
(add-to-load-path "elisp" "elpa")



;; ---------------------------------------------------------------------------------
;;; @ optional key bind setting

;; 後方の1文字を削除する(shellと同じ設定にする)
;; 元は, ヘルプコマンドを呼び出すキー
(define-key global-map (kbd "C-h") 'delete-backward-char)
;; anything: anything-interfaceを表示する
;; 元は, 位置はそのままに改行をいれてくれるキー
(define-key global-map (kbd "C-o") 'anything)
;; 他のウィンドウに移動する
;; 元は, 前後の文字を入れ替えるキー
(define-key global-map (kbd "C-t") 'other-window)
;; mozc: 入力メソッドを切り替える
;; 元は, 後続のコマンド向けの前置引数を指定するキー
(define-key global-map (kbd "C-u") 'mozc-mode)
;; redo+: redoを実行する
(define-key global-map (kbd "C-'") 'redo)
;; anything: anythingを復元する
(define-key global-map (kbd "C-=") 'anything-resume)
;; 行の見えない部分を折り返すかどうかを切り替える
;; 元は, toggle-input-modeという入力切り替えをするキー
(define-key global-map (kbd "C-\\") 'toggle-truncate-lines)


;; undo-tree: undo-treeを表示する. qで終了する
;; 元は, ただのundoに設定されている
(define-key global-map (kbd "C-x u") 'undo-tree-visualize)


;; 正規表現を用いて桁揃えをする
(define-key global-map (kbd "C-c a") 'align-regexp)
;; Emacs内からコンパイル命令をする
(define-key global-map (kbd "C-c c") 'compile)
;; anything-c-moccur: バッファ内を, 指定した文字列でインクリメンタルサーチする
(define-key global-map (kbd "C-c o") 'anything-c-moccur-occur-by-moccur)
;; yasnippet: スニペットを展開する
(define-key global-map (kbd "C-c e") 'yas-expand)
;; yasnippet: 既存スニペットを挿入する
(define-key global-map (kbd "C-c i") 'yas-insert-snippet)
;; yasnippet: 新規スニペットを作成する. C-c C-cで新規保存し, C-x C-sで既存のを上書き保存する
(define-key global-map (kbd "C-c n") 'yas-new-snippet)
;; sr-speedbar: speedbarを表示するかどうかを切り替える
(define-key global-map (kbd "C-c s") 'sr-speedbar-toggle)
;; DafaultでのC-uコマンドで, 入力を読み取り、後続のコマンド向けの前置引数を指定する
;; 指定したディレクトリ以下を全てバイトコンパイルするには以下のコマンドを実行する
;; C-c u 0 M-x byte-recompile-directory
(define-key global-map (kbd "C-c u") 'universal-argument)
;; yasnippet: 既存スニペットを閲覧/編集する
(define-key global-map (kbd "C-c v") 'yas-visit-snippet-file)
;; anything: killringを表示する
(define-key global-map (kbd "C-c y") 'anything-show-kill-ring)
;; bm: マークした後方の記憶位置に移動する
(define-key global-map (kbd "C-c [") 'bm-previous)
;; bm: マークした前方の記憶位置に移動する
(define-key global-map (kbd "C-c ]") 'bm-next)
;; bm: カーソル位置を記憶(マーク)する
(define-key global-map (kbd "C-c SPC") 'bm-toggle)


;; tabbar: 右のタブに移動する
;; 元は, next-word = M-f キー
(define-key global-map (kbd "<M-right>") 'tabbar-forward-tab)
;; tabbar: 左のタブに移動する
;; 元は, previous-word = M-b キー
(define-key global-map (kbd "<M-left>") 'tabbar-backward-tab)
;; flymake: 後方のエラーへ移動する
(define-key global-map (kbd "M-[") 'flymake-goto-prev-error)
;; flymake: 前方のエラーへ移動する
(define-key global-map (kbd "M-]") 'flymake-goto-next-error)



;; ---------------------------------------------------------------------------------
;;; @ plugins

;;; @ auto-install : installからの配置を自動化する

(require 'auto-install)
;; インストールディレクトリを指定する
(setq auto-install-directory "~/.emacs.d/elisp/")
;; # 使用する時に以下のコメントをはずす
;;  (auto-install-compatibility-setup)
;;  (auto-install-update-emacswiki-package-name t)



;;; @ auto-complete : コードの補完をする

(require 'auto-complete-config)
;; グローバルモードに指定する
(global-auto-complete-mode t)
;; 辞書を保存する場所
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;; キャッシュを保存する場所
(setq ac-comphist-file "~/.emacs.d/cache/auto-complete/ac-comphist.dat")



;;; @ mozc : 日本語変換をサポートする

(require 'mozc)
;; mozcをデフォルトのinput-methodに指定する
(setq default-input-method "japanese-mozc")



;;; @ migemo : 日本語をローマ字で検索可能にする

(require 'migemo)
;; cmigemoの設定
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix) ; cmigemoをutf-8で使用する
(load-library "migemo")
(migemo-init)
;; キャッシュを保存する場所
(setq migemo-pattern-alist-file "~/.emacs.d/cache/migemo/migemo-pattern")
(setq migemo-frequent-pattern-alist-file "~/.emacs.d/cache/migemo/migemo-frequent")



;;; @ bm : カーソルの位置を記憶, 移動可能にする

(require 'bm)
;; 永続性をもたせる
(setq-default bm-buffer-persistence t)
;; キャッシュを保存する場所
(setq bm-repository-file "~/.emacs.d/cache/bm/.bm-repository")
;; 起動時に設定をロードする
(add-hook' after-init-hook 'bm-repository-load)
(add-hook 'find-file-hooks 'bm-buffer-restore)
(add-hook 'after-revert-hook 'bm-buffer-restore)
;; 終了時に設定をセーブする
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'auto-save-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))



;;; @ redo+ : redoを可能にする

(require 'redo+)
;; 過去のundoはredoしない
(setq undo-no-redo t)
;; 大量のundoに耐えられるようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)



;;; @ undo-tree : undo/redoをツリー構造のCUI上で実行する

(require 'undo-tree)
;; global-minor-modeに指定する
(global-undo-tree-mode t)



;;; @ sr-speedbar : ファイルやディレクトリを操作するメニューを表示する

(require 'sr-speedbar)
;; 左側に表示する
(setq sr-speedbar-right-side nil)



;;; @ tabbar : バッファをタブで管理する

(require 'tabbar)
(tabbar-mode t)
(tabbar-mwheel-mode -1) ; タブ上でマウスホイールの操作を無効にする
(setq tabbar-buffer-groups-function nil) ; グループ化しない
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil)))) ; 左に表示されるボタンを無効化する
(setq tabbar-separator '(1.5))    ; タブの長さの設定
;; 外観の設定
(set-face-attribute 'tabbar-default nil
		    :family "Comic Sans MS"
		    :background "black"
		    :foreground "gray72"
		    :height 1.0)            ; defaultの設定
(set-face-attribute 'tabbar-unselected nil
		    :background "black"
		    :foreground "grey72"
		    :box nil)               ; 選択されていない項目の設定
(set-face-attribute 'tabbar-selected nil
		    :background "black"
		    :foreground "yellow"
		    :box nil)               ; 選択されている項目の設定
(set-face-attribute 'tabbar-button nil
		    :box nil)
(set-face-attribute 'tabbar-separator nil
		    :height 1.5)
;; *scratch*バッファ以外の * で始まるバッファはタブに表示しないように設定する
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; カレントバッファは必ずいれる
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
		     ((equal "*scratch*" (buffer-name b)) b)
		     ((char-equal ?* (aref (buffer-name b) 0)) nil)
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)



;;; @ eldoc : Elisp-modeで, 関数/変数のヘルプをエコーエリアに表示する

(require 'eldoc-extension)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)       ; すぐに表示する
(setq eldoc-minor-mode-string "") ; モードラインにElDocと表示しない



;;; @ paredit : Elisp-modeで, 括弧の対応が崩れにくいコマンドを提供する
;; カーソル位置/リージョンを括弧で,  M-( で挟み, M-s で外せる 

(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)



;;; @ anything : 統合インタフェースを提供する

(require 'anything-config)
(require 'anything-startup)
(require 'descbinds-anything)    ; describe-bindingsをanythingで開けるようにする
(require 'anything-match-plugin) ; anythingの検索で, AND検索を可能にする
;; 表示する項目の設定
(setq anything-sources
      (list anything-c-source-buffers              ; 現在開いているバッファ一覧
	    anything-c-source-files-in-current-dir ; カレントディレクトリ内一覧
	    anything-c-source-recentf              ; 最近開いたファイル一覧
	    anything-c-source-buffer-not-found     ; 見つからない場合に新規バッファ作成
	    anything-c-source-emacs-commands))     ; Emacsコマンドの実行履歴一覧
;; 最大表示個数の設定
(add-to-list 'descbinds-anything-source-template '(candidate-number-limit . 1000))
;; レスポンスなどの設定
(setq anything-input-idle-delay       0.1  ; 文字列を入力してから描写するまでの遅延時間
      anything-idle-delay             0.5  ; 同上, (Delayed)扱いされた情報源に適用する
      anything-quick-update           nil  ; 表示されている情報源以外を(Delayed)扱いする
      anything-candidate-number-limit  50) ; 1情報源に表示される最大候補数



;;; @ anything-c-moccur : anythingとoccurを併せて, バッファ内での文字列検索を便利にする

(require 'color-moccur)
(require 'anything-c-moccur)
;; スペースで区切られた複数の単語にマッチさせる
(setq moccur-split-word t)



;;; @ yasnippet : コード片から定型コードなどを素早く展開する

(require 'yasnippet)
;; 問い合わせを簡略化 yes/no を y/n にする
(fset 'yes-or-no-p 'y-or-n-p)
;; スニペットを保存する場所
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
;; グローバルマイナーモードに指定する
(yas-global-mode t)
;; スニペットでanything interfaceを使用する
(eval-after-load "anything-config"
  '(progn
     (defun my-yas/prompt (prompt choices &optional display-fn)
       (let* ((names (loop for choice in choices
                           collect (or (and display-fn (funcall display-fn choice))
                                       choice)))
              (selected (anything-other-buffer
                         `(((name . ,(format "%s" prompt))
                            (candidates . names)
                            (action . (("Insert snippet" . (lambda (arg) arg))))))
                         "*anything yas/prompt*")))
         (if selected
             (let ((n (position selected names :test 'equal)))
               (nth n choices))
           (signal 'quit "user quit!"))))
     (custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))
     (define-key anything-command-map (kbd "y") 'yas-insert-snippet)))
;; snippet-mode を *.yasnippet files で使用する
(add-to-list 'auto-mode-alist '("\\.yasnippet$" . snippet-mode))



;;; @ flymake : リアルタイムにプログラミング言語の文法チェックをする

(require 'flymake)
;; エラー箇所を移動した際に, エラーメッセージをminibufferに表示する
(defun display-error-message ()
  (message (get-char-property (point) 'help-echo)))
(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (display-error-message))
(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)



;;; @ flymake - c-mode setting

;; c-mode実行時にflymake-modeを実行する
(add-hook 'c-mode-hook (lambda () (flymake-mode t)))
;; cのflymakeでmakefileを不要にする
(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
(push '("\\.h$" flymake-c-init) flymake-allowed-file-name-masks)



;;; @ flymake - c++-mode setting

;; c++-mode実行時にflymake-modeを実行する
(add-hook 'c++-mode-hook (lambda () (flymake-mode t )))
;; c++のflymakeでmakefileを不要にする
(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(push '("\\.cc$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.h$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.hpp$" flymake-cc-init) flymake-allowed-file-name-masks)



;; ---------------------------------------------------------------------------------
