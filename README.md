gmail.vim
=========

Description
-----------
vim���gmail�����邽�߂̃X�N���v�g�ł��B
imap���g���ă��[���𑀍삷��̂ŁAgmail���̐ݒ��imap��L���ɂ���K�v������܂��B


Requirements
------------
�K�v�Ȃ̂��͎̂��̂Ƃ���B

* vimproc

    git://github.com/Shougo/vimproc.git

* openssl
Windows��msysgit�Ɋ܂܂��openssl�œ���m�F�����Ă��܂��B

    http://code.google.com/p/msysgit/


Setting
-------

* imap�̗L����

    gmail�̐ݒ��imap��L���ɂ��Ă��������B�����̓E�F�u�ŁB

* vimproc�̃C���X�g�[��

* openssl�Ƀp�X��ʂ�
    
    let &path = $path . 'c:\Program files\git\bin'

* �K�v�Ȃ玟�̂悤�Ȑݒ��vimrc�ɋL�ڂ���B�i�K�{�ł͂Ȃ�)

  - �T�[�o�[�̐ݒ�i�f�t�H���g�͈ȉ��̂Ƃ���)

    let g:gmail_imap = 'imap.gmail.com:993'

    let g:gmail_smtp = 'smtp.gmail.com:465'

  - ���[�U�[���̎w��

    let g:gmail_user_name = 'xxx@gmail.com'

  - ���[�����M���̏���

    let g:gmail_signature = '# ' . g:gmail_user_name . '(by gmail.vim)'


Usage
-----

* �N��

���̃R�}���h�������������ł��B

    :Gmail

* ����

�擪�s�ɕ\������Ă�����̂����j���[�ł��B�s������������Enter�L�[�������Ă��������B


ScreenShots
-----------

* ����C���[�W
xxx

Other
-----------

* ���쌠�E�Ɛӓ�
�{�X�N���v�g�ɂ���Ĕ����������ړI�A�ԐړI�ɐ����������Ȃ闘�v�̑�����
���Q�ɑ΂��Ă���҂͈�؂̐ӔC�𕉂��܂���B
�����鑹�Q�̖Ɛӂ������������������Ƃ��g�p�����Ƃ��܂��B


HISTORY
-------
xxx

