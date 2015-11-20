use inc::Module::Install;

RTx     'RT-Extension-Addressbook';
license 'gplv2';
repository 'https://github.com/bestpractical/rt-extension-addressbook';

requires_rt '4.0.0';
rt_too_new '4.4.0';

sign;
WriteAll;
