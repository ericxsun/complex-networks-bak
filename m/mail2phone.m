function mail2phone(email_account, password, subject, content)
%MAIL2PHONE send an email to 139.mail
%
%Syntax: 
% MAIL2PHONE(email_account, password, subject, content)
%
% email_account:
% password:
%  subject: the title
%  content: the body
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
narginchk(0, 2);

if nargin == 0
    subject = '';
    content = '';
elseif nargin == 1
    content = '';
end

from_mailAddr = email_account;
password      = password';

to_mailAddr = from_mailAddr;

setpref('Internet', 'E_mail', from_mailAddr);
setpref('Internet', 'SMTP_Server', 'smtp.139.com');
setpref('Internet', 'SMTP_Username', from_mailAddr);
setpref('Internet', 'SMTP_Password', password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth', 'true');
% props.setProperty('mail.smtp.socketFactory.class', ...
%                   'javax.net.ssl.SSLSocketFactory');
% props.setProperty('mail.smtp.socketFactory.prot', '465');

fprintf('send email to %m\n', email_account);

sendmail(to_mailAddr, subject, content);

fprintf('finish\n');
%--------------------------------------------------------------------------
end