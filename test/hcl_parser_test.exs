defmodule HCLParserTest do
  use ExUnit.Case
  doctest HCLParser

  test "reads a provider" do
    tf_code = 'provider "google" {}'
    expected = %{"provider" => %{"google" => {}}}

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end

  test "reads a provider with settings" do
    tf_code = 'provider "google" {
      project     = "my-project-id"
      region      = "us-central1"
    }'

    expected = %{
      "provider" => %{
        "google" => %{
          "project" => "my-project-id",
          "region" => "us-central1"
        }
      }
    }

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end

  test "can read an empty resource" do
    tf_code = 'resource "google_compute_instance" "default" {}'

    expected = %{
      "resource" => %{"google_compute_instance" => %{"default" => {}}}
    }

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end

  test "can read an used resource" do
    tf_code = '
    resource "google_compute_instance" "default" {
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

    expected = %{
      "resource" => %{
        "google_compute_instance" => %{
          "default" => %{
            "name" => "test",
            "zone" => "us-central1-a",
            "machine_type" => "n1-standard-1",
            "tags" => ["foo", "bar"],
            "allow_stopping_for_update" => true,
            "metadata" => %{"foo" => "bar"},
            "service_account" => %{"scopes" => ["userinfo-email", "compute-ro", "storage-ro"]}
          }
        }
      }
    }

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end

  test "can read an used resource with a provider" do
    tf_code = '
    provider "google" {
      project     = "my-project-id"
      region      = "us-central1"
    }

    resource "google_compute_instance" "default" {
      name         = "test"
      machine_type = "n1-standard-1"
      zone         = "us-central1-a"
      tags         = ["foo", "bar"]
      allow_stopping_for_update = true
      service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
      }
    }
    '

    expected = %{
      "resource" => %{
        "google_compute_instance" => %{
          "default" => %{
            "name" => "test",
            "zone" => "us-central1-a",
            "machine_type" => "n1-standard-1",
            "tags" => ["foo", "bar"],
            "allow_stopping_for_update" => true,
            "service_account" => %{"scopes" => ["userinfo-email", "compute-ro", "storage-ro"]}
          }
        }
      },
      "provider" => %{"google" => %{"project" => "my-project-id", "region" => "us-central1"}}
    }

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end

  test "can multiple resources in same block sub location" do
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

    expected = %{
      "resource" => %{
        "google_compute_instance" => %{
          "test1" => %{
            "name" => "test",
            "zone" => "us-central1-a",
            "machine_type" => "n1-standard-1",
            "tags" => ["foo", "bar"],
            "allow_stopping_for_update" => true,
            "metadata" => %{"foo" => "bar"},
            "service_account" => %{"scopes" => ["userinfo-email", "compute-ro", "storage-ro"]}
          },
          "test2" => %{
            "allow_stopping_for_update" => true,
            "machine_type" => "n1-standard-1",
            "metadata" => %{"foo" => "bar"},
            "name" => "test",
            "service_account" => %{"scopes" => ["userinfo-email", "compute-ro", "storage-ro"]},
            "tags" => ["foo", "bar"],
            "zone" => "us-central1-a"
          }
        }
      }
    }

    assert HCLParser.parse(tf_code) == {:ok, expected}
  end
end
