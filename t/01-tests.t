#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::LongString;

use lib 't/lib';

use TestForm;

plan tests => 5;

my $test_spec = {
'rules' => {
   'password' => {
       'remote' => {
         'url' => '/ajax/formvalidator/TestForm/password',
         'data' => 'data_collector',
         'type' => 'POST'
       }
     },
   'password2' => {
        'remote' => {
          'type' => 'POST',
          'data' => 'data_collector',
          'url' => '/ajax/formvalidator/TestForm/password2'
        }
      },
   'lname' => {
    'remote' => {
      'type' => 'POST',
      'data' => 'data_collector',
      'url' => '/ajax/formvalidator/TestForm/lname'
    }
  },
   'fname' => {
    'remote' => {
      'data' => 'data_collector',
      'url' => '/ajax/formvalidator/TestForm/fname',
      'type' => 'POST'
    }
  },
   'email' => {
    'remote' => {
      'type' => 'POST',
      'url' => '/ajax/formvalidator/TestForm/email',
      'data' => 'data_collector'
    }
  }
     },
'messages' => {}
};

my $test_js1 = 
q[  var data_collector = {
    "TestForm.email": function () { return $("#TestForm\\\\.email").val() },
    "TestForm.fname": function () { return $("#TestForm\\\\.fname").val() },
    "TestForm.lname": function () { return $("#TestForm\\\\.lname").val() },
    "TestForm.password": function () { return $("#TestForm\\\\.password").val() },
    "TestForm.password2": function () { return $("#TestForm\\\\.password2").val() }
  };];

my $test_js2 = 
q[  $(document).ready(function() {
    $.getScript("http://ajax.aspnetcdn.com/ajax/jquery.validate/1.14.0/jquery.validate.min.js", function () {
      if (typeof validation_spec !== 'undefined') {
        $('form#TestForm').validate({
          rules: validation_spec.rules,
          messages: validation_spec.messages,
          highlight: function(element) {
            $(element).closest('.form-group').removeClass('success').addClass('error');
          },
          success: function(element) {
            element
            .text('dummy').addClass('valid')
            .closest('.form-group').removeClass('error').addClass('success');
          }
        });
      }
    });
  });];

my $form = TestForm->new;

my $spec = $form->_data_for_validation_spec;
my $js = $form->_js_code_for_validation_scripts;
my $html = $form->render;

is_deeply($spec, $test_spec);

contains_string($js, $test_js1, 'javascript data_collector generated OK');
contains_string($js, $test_js2, 'javascript doc_ready generated OK');
contains_string($html, $test_js1, 'javascript data_collector in HTML');
contains_string($html, $test_js2, 'javascript doc_ready in HTML');


