use inc::Module::Install;
all_from '/home/ytnobody/work/Xceptor/lib/Xceptor.pm';

requires 'Nephia' => 0.01;

tests 't/*.t';

test_requires 'Test::More';

WriteAll;