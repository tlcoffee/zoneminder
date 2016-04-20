package WSNotification::Interfaces::WSBaseNotificationSender::NotificationProducerPort;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);
use base qw(SOAP::WSDL::Client::Base);

# only load if it hasn't been loaded before
require WSNotification::Typemaps::WSBaseNotificationSender
    if not WSNotification::Typemaps::WSBaseNotificationSender->can('get_class');

sub START {
    $_[0]->set_proxy('http://docs.oasis-open.org/wsn/bw-2') if not $_[2]->{proxy};
    $_[0]->set_class_resolver('WSNotification::Typemaps::WSBaseNotificationSender')
        if not $_[2]->{class_resolver};

    $_[0]->set_prefix($_[2]->{use_prefix}) if exists $_[2]->{use_prefix};
}

sub Subscribe {
    my ($self, $body, $header) = @_;
    die "Subscribe must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'Subscribe',
        soap_action => 'http://docs.oasis-open.org/wsn/bw-2/Subscribe',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( WSNotification::Elements::Subscribe )],

        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub GetCurrentMessage {
    my ($self, $body, $header) = @_;
    die "GetCurrentMessage must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'GetCurrentMessage',
        soap_action => 'http://docs.oasis-open.org/wsn/bw-2/GetCurrentMessage',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( WSNotification::Elements::GetCurrentMessage )],

        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}




1;



__END__

=pod

=head1 NAME

WSNotification::Interfaces::WSBaseNotificationSender::NotificationProducerPort - SOAP Interface for the WSBaseNotificationSender Web Service

=head1 SYNOPSIS

 use WSNotification::Interfaces::WSBaseNotificationSender::NotificationProducerPort;
 my $interface = WSNotification::Interfaces::WSBaseNotificationSender::NotificationProducerPort->new();

 my $response;
 $response = $interface->Subscribe();
 $response = $interface->GetCurrentMessage();



=head1 DESCRIPTION

SOAP Interface for the WSBaseNotificationSender web service
located at http://docs.oasis-open.org/wsn/bw-2.

=head1 SERVICE WSBaseNotificationSender



=head2 Port NotificationProducerPort



=head1 METHODS

=head2 General methods

=head3 new

Constructor.

All arguments are forwarded to L<SOAP::WSDL::Client|SOAP::WSDL::Client>.

=head2 SOAP Service methods

Method synopsis is displayed with hash refs as parameters.

The commented class names in the method's parameters denote that objects
of the corresponding class can be passed instead of the marked hash ref.

You may pass any combination of objects, hash and list refs to these
methods, as long as you meet the structure.

List items (i.e. multiple occurences) are not displayed in the synopsis.
You may generally pass a list ref of hash refs (or objects) instead of a hash
ref - this may result in invalid XML if used improperly, though. Note that
SOAP::WSDL always expects list references at maximum depth position.

XML attributes are not displayed in this synopsis and cannot be set using
hash refs. See the respective class' documentation for additional information.



=head3 Subscribe



Returns a L<WSNotification::Elements::SubscribeResponse|WSNotification::Elements::SubscribeResponse> object.

 $response = $interface->Subscribe( {
    ConsumerReference =>  { # WSNotification::Types::EndpointReferenceType
      Address =>  { value => $some_value },
      ReferenceParameters =>  { # WSNotification::Types::ReferenceParametersType
      },
      Metadata =>  { # WSNotification::Types::MetadataType
      },
    },
    Filter =>  { # WSNotification::Types::FilterType
      TopicExpression =>  { # WSNotification::Types::TopicExpressionType
      },
      MessageContent =>  { # WSNotification::Types::QueryExpressionType
      },
    },
    InitialTerminationTime => $some_value, # AbsoluteOrRelativeTimeType
    SubscriptionPolicy =>  {
    },
  },,
 );

=head3 GetCurrentMessage



Returns a L<WSNotification::Elements::GetCurrentMessageResponse|WSNotification::Elements::GetCurrentMessageResponse> object.

 $response = $interface->GetCurrentMessage( {
    Topic =>  { # WSNotification::Types::TopicExpressionType
    },
  },,
 );



=head1 AUTHOR

Generated by SOAP::WSDL on Fri Aug  8 16:49:21 2014

=cut
