class CheckExpiredReservationWorker
  include Sidekiq::Worker

  def perform(*args)
    p "CheckExpiredReservationWorker date: " + DateTime.now.strftime("%Y-%m-%d %H:%M:%S %z")

    @expiredPerionMin = ENV['RESERVATION_EXPIRED_PERIOD_MIN'].to_i

    Reservation.all.each do |reservation|

      @endPeriod = reservation.from + @expiredPerionMin.minutes
      p "CheckExpiredReservationWorker reservation from: " + reservation.from.strftime("%Y-%m-%d %H:%M:%S %z") + " to: " + @endPeriod.strftime("%Y-%m-%d %H:%M:%S %z")

      if DateTime.now > @endPeriod

        p "CheckExpiredReservationWorker mark as expired id: " + reservation.id.to_s

        reservation.to = DateTime.now
        reservation.save
      end
    end
  end
end
