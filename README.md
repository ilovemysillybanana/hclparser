# HCLParser

A package to read Terraform 0.12.0 into an elixir manageable data structure.

## Usage

```elixir

# get a string of code, whether its from you or a file

tf_code = '
    resource "google_compute_instance" "test1" {
      name         = "test"
      machine_type = "n1-standard-1"
      zone         = "us-central1-a"
      tags         = ["foo", "bar"]
      allow_stopping_for_update = true
      service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
      }
      metadata = {
        foo = "bar"
      }
    }

    resource "google_compute_instance" "test2" {
      name         = "test"
      machine_type = "n1-standard-1"
      zone         = "us-central1-a"
      tags         = ["foo", "bar"]
      allow_stopping_for_update = true
      service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
      }
      metadata = {
        foo = "bar"
      }
    }
    '
  HCLParser.parse(tf_code)

  # returns the following:
  ex(2)> HCLParser.parse(tf_code)
HCLParser.parse(tf_code)
{:ok,
 %{
   resource: %{
     "google_compute_instance" => %{
       "test1" => %{
         allow_stopping_for_update: true,
         machine_type: "n1-standard-1",
         metadata: %{foo: "bar"},
         name: "test",
         service_account: %{
           scopes: ["userinfo-email", "compute-ro", "storage-ro"]
         },
         tags: ["foo", "bar"],
         zone: "us-central1-a"
       },
       "test2" => %{
         allow_stopping_for_update: true,
         machine_type: "n1-standard-1",
         metadata: %{foo: "bar"},
         name: "test",
         service_account: %{
           scopes: ["userinfo-email", "compute-ro", "storage-ro"]
         },
         tags: ["foo", "bar"],
         zone: "us-central1-a"
       }
     }
   }
 }}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hclparser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hclparser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hclparser](https://hexdocs.pm/hclparser).

