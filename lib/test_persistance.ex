defmodule TestPersistance do
  require Ash.Query

  def run do
    for i <- 0..5 do
      ticket =
        Helpdesk.Support.Ticket
        |> Ash.Changeset.for_create(:open, %{subject: "Issue #{i}"})
        |> Helpdesk.Support.create!()

      if rem(i, 2) == 0 do
        ticket
        |> Ash.Changeset.for_update(:close)
        |> Helpdesk.Support.update!()
      end
    end

    # Show the tickets where the subject contains "2"
    Helpdesk.Support.Ticket
    |> Ash.Query.filter(contains(subject, "2"))
    |> Helpdesk.Support.read!()

    # Show the tickets that are closed and their subject does not contain "4"
    Helpdesk.Support.Ticket
    |> Ash.Query.filter(status == :closed and not contains(subject, "4"))
    |> Helpdesk.Support.read!()
  end
end
