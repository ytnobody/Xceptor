use inc::Module::Install;
all_from '/home/ytnobody/work/Xceptor/lib/Xceptor.pm';

requires 'Nephia' => 0.01;
requires 'File::Spec' => 0;
requires 'FindBin' => 0;
requires 'Teng' => 0.17;

tests 't/*.t';

test_requires 'Test::More';
test_requires 'File::Which';

WriteAll;
