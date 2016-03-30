Set(
    $Addressbook,
    {
        table            => 'AddressBooks',
        email_col        => 'Address',
        use_queue_col    => 1,
        queue_col        => 'IdQueue',
        use_disabled_col => 1,
        disabled_col     => 'Disabled',
    }
);

1;
