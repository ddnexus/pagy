>>> Pick a configuration...

+++ Sync

!!!success Works with any app
!!!

The following statement will copy and keep synced your picked `pagy*` file in your own `{{ $.remote_dir }}` dir _(or any dir you may want use)_.

It will become and processed exactly like one of your own files.

```rb [pagy.rb initializer](/toolbox/configuration/initializer)
# Replace 'pagy*' with the file you picked
Pagy.sync({{ $.resource }}, Rails.root.join('{{ $.remote_dir }}'), 'pagy*') if Rails.env.development?
```
==- Sync Task

If you prefer to sync manually or during an automation step, you can define your own task with a single line in the `Rakefile`, or any `*.rake` file:

```rb
# Pagy::SyncTask.new(resource, destination, *targets)
# Replace 'pagy*' with the file you picked
Pagy::SyncTask.new({{ $.resource }}, Rails.root.join('{{ $.remote_dir }}'), 'pagy*')
```

and exec it with...

```sh
bundle exec rake pagy:sync{{ $.resource }}
```
===

+++ Pipeline

!!!warning Works only with apps with an assets pipeline
!!!

```rb
Rails.application.config.assets.paths << Pagy::ROOT.join('{{ $.resource_dir }}')
```

+++