(require 'dockerfile-mode)
(require 'company)

(defconst docker-instructions
  '("FROM " "MAINTAINER " "RUN " "CMD " "EXPOSE " "ENV " "ARG "
    "ADD " "COPY " "ENTRYPOINT " "VOLUME " "USER " "WORKDIR " "ONBUILD "
    "LABEL " "STOPSIGNAL " "SHELL " "HEALTHCHECK "))

(defun docker-instructions-company-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'docker-instructions-company-backend))
    (prefix (and (eq major-mode 'dockerfile-mode)
                 (company-grab-line "^[a-zA-Z|/]+$")))
    (candidates
     (if (string-equal "/" arg) docker-instructions ; use / to list all
       (seq-filter (lambda (c) (string-prefix-p arg c t)) docker-instructions)))
    (sorted t)
    (no-cache t)))

(add-hook
 'dockerfile-mode-hook
 (lambda ()
   (add-to-list 'company-backends 'docker-instructions-company-backend)))
