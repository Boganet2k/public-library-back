class CheckExpiredReservationWorker
  include Sidekiq::Worker

  def perform(*args)
    p "CheckExpiredReservationWorker date: " + DateTime.now.strftime("%Y-%m-%d %H:%M:%S %z")

    Reservation.all.each do |reservation|

      @toPlus1Min = reservation.from + 1.minutes
      p "CheckExpiredReservationWorker @toPlus1Min: " + @toPlus1Min.strftime("%Y-%m-%d %H:%M:%S %z")

      if DateTime.now > @toPlus1Min

        p "CheckExpiredReservationWorker mark as expired id: " + reservation.id.to_s

        reservation.to = DateTime.now
        reservation.save
      end
    end
  end
end
