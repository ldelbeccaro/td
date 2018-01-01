require 'spec_helper'

describe RecurringHelper do

  describe '#weekdays' do
    it 'returns the correct weekday' do
      expect(helper.weekdays([1])).to eq(['sunday'])
      expect(helper.weekdays([7])).to eq(['saturday'])
    end

    it 'returns multiple correct weekdays' do
      expect(helper.weekdays([1, 3])).to eq(['sunday', 'tuesday'])
      expect(helper.weekdays([7, 2])).to eq(['saturday', 'monday'])
    end

    it 'raises an error if weekday is invalid' do
      expect { helper.weekdays([0]) }.to raise_error.with_message('Invalid weekday')
      expect { helper.weekdays([9]) }.to raise_error.with_message('Invalid weekday')
      expect { helper.weekdays(['hi']) }.to raise_error.with_message('Invalid weekday')
    end
  end

  describe '#month' do
    it 'returns the correct month' do
      expect(helper.month(1)).to eq('january')
      expect(helper.month(7)).to eq('july')
    end

    it 'raises an error if month is invalid' do
      expect { helper.month(0) }.to raise_error.with_message('Invalid month')
      expect { helper.month(40) }.to raise_error.with_message('Invalid month')
      expect { helper.month('hi') }.to raise_error.with_message('Invalid month')
    end
  end

  describe '#ordinals' do
    it 'returns \'rd\' if number ends in 3, except *13' do
      expect(helper.ordinals([3])).to eq(['3rd'])
      expect(helper.ordinals([2353])).to eq(['2353rd'])
      expect(helper.ordinals([13])).to eq(['13th'])
      expect(helper.ordinals([213])).to eq(['213th'])
    end

    it 'returns \'nd\' if number ends in 2, except *12' do
      expect(helper.ordinals([2])).to eq(['2nd'])
      expect(helper.ordinals([02])).to eq(['2nd'])
      expect(helper.ordinals([12])).to eq(['12th'])
      expect(helper.ordinals([312])).to eq(['312th'])
    end

    it 'returns \'st\' if number ends in 1, except *11' do
      expect(helper.ordinals([1])).to eq(['1st'])
      expect(helper.ordinals([31])).to eq(['31st'])
      expect(helper.ordinals([11])).to eq(['11th'])
      expect(helper.ordinals([111])).to eq(['111th'])
    end

    it 'returns \'th\' if number ends in anything else' do
      expect(helper.ordinals([4])).to eq(['4th'])
      expect(helper.ordinals([23985])).to eq(['23985th'])
      expect(helper.ordinals([0])).to eq(['0th'])
    end
  end

  describe '#add_and' do
    it 'returns the first element of an array of length 1' do
      expect(helper.add_and([1])).to eq('1')
      expect(helper.add_and(['hello'])).to eq('hello')
    end

    it 'adds and between elements of an array of length 2' do
      expect(helper.add_and([1, 2])).to eq('1 and 2')
      expect(helper.add_and(['hello', 'goodbye'])).to eq('hello and goodbye')
    end

    it 'adds commands & and between elements of an array of length > 2' do
      expect(helper.add_and([1, 2, 3])).to eq('1, 2 and 3')
      expect(helper.add_and([1, 2, 3, 4, 5])).to eq('1, 2, 3, 4 and 5')
      expect(helper.add_and(['hello', 'goodbye', 'for now'])).to eq('hello, goodbye and for now')
    end
  end

  describe '#recurring_unit_text' do
    context 'for yearly reminders' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :yearly, text: 'recurring yearly' }
      let!(:todo) { FactoryGirl.create :todo, :due_today, recurring_todo: recurring_todo }

      it 'returns \'every year\' for 1 unit' do
        expect(helper.recurring_unit_text(todo)).to eq('every year')
      end

      it 'returns \'every X years\' for X units' do
        recurring_todo.recurring_interval_unit_number = 2
        recurring_todo.save

        expect(helper.recurring_unit_text(todo)).to eq('every 2 years')
      end
    end

    context 'for monthly reminders' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, text: 'recurring monthly' }
      let!(:todo) { FactoryGirl.create :todo, :due_today, recurring_todo: recurring_todo }

      it 'returns \'every month\' for 1 unit' do
        expect(helper.recurring_unit_text(todo)).to eq('every month')
      end

      it 'returns \'every X months\' for X units' do
        recurring_todo.recurring_interval_unit_number = 2
        recurring_todo.save

        expect(helper.recurring_unit_text(todo)).to eq('every 2 months')
      end
    end

    context 'for weekly reminders' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :weekly, text: 'recurring yearly' }
      let!(:todo) { FactoryGirl.create :todo, :due_today, recurring_todo: recurring_todo }

      it 'returns \'every week\' for 1 unit' do
        expect(helper.recurring_unit_text(todo)).to eq('every week')
      end

      it 'returns \'every X weeks\' for X units' do
        recurring_todo.recurring_interval_unit_number = 2
        recurring_todo.save

        expect(helper.recurring_unit_text(todo)).to eq('every 2 weeks')
      end
    end

    context 'for daily reminders' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :daily, text: 'recurring daily' }
      let!(:todo) { FactoryGirl.create :todo, :due_today, recurring_todo: recurring_todo }

      it 'returns \'every day\' for 1 unit' do
        expect(helper.recurring_unit_text(todo)).to eq('every day')
      end

      it 'returns \'every X days\' for X units' do
        recurring_todo.recurring_interval_unit_number = 2
        recurring_todo.save

        expect(helper.recurring_unit_text(todo)).to eq('every 2 days')
      end
    end
  end

  describe '#recurring_date_text' do
    context 'for after completion todos' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :daily, :after_completion, text: 'recurring daily after completion' }
      let!(:todo) { FactoryGirl.create :todo, :due_today, recurring_todo: recurring_todo }
      let!(:recurring_todo_2) { FactoryGirl.create :recurring_todo, :yearly, :after_completion, text: 'recurring yearly after completion' }
      let!(:todo_2) { FactoryGirl.create :todo, :due_in_past, :completed_in_past, recurring_todo: recurring_todo }

      it 'returns correct text for after completion' do
        expect(helper.recurring_date_text(todo)).to eq(' after completion')
        expect(helper.recurring_date_text(todo_2)).to eq(' after completion')
      end
    end

    context 'for on schedule todos' do
      context 'for yearly reminders' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :yearly, :on_schedule, text: 'recurring yearly on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        it 'returns correct date' do
          expect(helper.recurring_date_text(todo)).to eq(' on december 13th')
        end
      end

      context 'for monthly reminders' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, :on_schedule, text: 'recurring monthly on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for relative weekdays' do
          it 'returns one weekday and one week number for arrays of length [1,1]' do
            recurring_todo.recurring_interval_weeks = [2]
            recurring_todo.recurring_interval_days = [2]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 2nd monday of the month')
          end

          it 'returns one weekday and multiple week numbers for arrays of length [1,>1]' do
            recurring_todo.recurring_interval_weeks = [2]
            recurring_todo.recurring_interval_days = [2, 4]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 2nd monday and wednesday of the month')            
          end

          it 'returns multiple weekdays and one week number for arrays of length [>1,1]' do
            recurring_todo.recurring_interval_weeks = [2, 3, 4]
            recurring_todo.recurring_interval_days = [7]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 2nd, 3rd and 4th saturday of the month')
          end

          it 'returns multiple weekdays and week numbers for arrays of length [>1,>1]' do
            recurring_todo.recurring_interval_weeks = [1, 2]
            recurring_todo.recurring_interval_days = [2, 5]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 1st and 2nd monday and thursday of the month')
          end
        end

        context 'for absolute dates' do
          it 'returns one date for an array of length 1' do
            recurring_todo.recurring_interval_days = [2]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 2nd of the month')
          end

          it 'returns multiple dates for an array of length > 1' do
            recurring_todo.recurring_interval_days = [1, 15]
            recurring_todo.save

            expect(helper.recurring_date_text(todo)).to eq(' on the 1st and 15th of the month')
          end
        end
      end

      context 'for weekly reminders' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :weekly, :on_schedule, text: 'recurring weekly on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        it 'returns one weekday for an array of length 1' do
          recurring_todo.recurring_interval_days = [3]
          recurring_todo.save

          expect(helper.recurring_date_text(todo)).to eq(' on tuesday')
        end

        it 'returns multiple weekdays for an array of length > 1' do
          recurring_todo.recurring_interval_days = [2, 3, 4, 5, 6]
          recurring_todo.save

          expect(helper.recurring_date_text(todo)).to eq(' on monday, tuesday, wednesday, thursday and friday')
        end
      end

      context 'for daily reminders' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :daily, :on_schedule, text: 'recurring daily on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        it 'returns an empty string' do
          expect(helper.recurring_date_text(todo)).to eq('')
        end
      end
    end
  end

  describe '#recurring_text' do
    let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, :on_schedule, text: 'recurring monthly on schedule', recurring_interval_unit_number: 2, recurring_interval_days: [2, 5], recurring_interval_weeks: [1, 2] }
    let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

    it 'returns recurring_unit_text + recurring_date_text' do
      expect(helper.recurring_text(todo)).to eq('every 2 months on the 1st and 2nd monday and thursday of the month')
    end
  end

  describe '#recurring_reference_date' do
    let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, :on_schedule, text: 'recurring monthly on schedule' }
    let!(:todo) { FactoryGirl.create :todo, :completed_today, due_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

    it 'returns due_date for scheduled recurring todos' do
      expect(helper.recurring_reference_date(todo)).to eq(todo.due_date)
    end

    it 'returns complete_date for after completion todos' do
      recurring_todo.recurring_type = 'after completion'
      recurring_todo.save

      expect(helper.recurring_reference_date(todo)).to eq(todo.complete_date)
    end
  end

  describe '#next_unit_in_array' do
    it 'returns the next highest element in an array' do
      expect(helper.next_unit_in_array(3, [1, 2, 4])).to eq(4)
      expect(helper.next_unit_in_array(2, [1, 2, 4])).to eq(4)
      expect(helper.next_unit_in_array(1, [1, 2, 4])).to eq(2)
    end

    it 'returns the first element in an array if there are no higher elements' do
      expect(helper.next_unit_in_array(4, [1, 2, 4])).to eq(1)
      expect(helper.next_unit_in_array(5, [1, 2, 4])).to eq(1)
      expect(helper.next_unit_in_array(2949, [1, 2, 4])).to eq(1)
    end
  end

  describe '#first_of_month' do
    it 'returns the first of the same month in the same year' do
      expect(helper.first_of_month(Date.today)).to eq(Date.new(Date.today.year, Date.today.month, 1))
      expect(helper.first_of_month(Date.new(2000, 1, 31))).to eq(Date.new(2000, 1, 1))
      expect(helper.first_of_month(Date.new(3000, 6, 28))).to eq(Date.new(3000, 6, 1))
      expect(helper.first_of_month(Date.new(2016, 2, 29))).to eq(Date.new(2016, 2, 1))
    end
  end

  describe '#next_recurring_todo_date' do
    context 'for yearly reminders' do
      let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :yearly, :after_completion, text: 'recurring yearly on schedule' }
      let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

      context 'for recurring_interval_unit_number = 1' do
        context 'for after completion todos' do
          it 'returns a date 1 year after complete date' do
            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,12,13))
          end
        end

        context 'for on schedule todos' do
          it 'returns a date 1 year after due date' do
            recurring_todo.recurring_type = 'on schedule'
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,11,13))
          end
        end
      end

      context 'for recurring_interval_unit_number > 1' do
        context 'for after completion todos'
          it 'returns a date X years after complete date' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2020,12,13))
          end
        end

        context 'for on schedule todos' do
          it 'returns a date X years after due date' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.recurring_type = 'on schedule'
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2020,11,13))
          end
        end
      end
    end

    context 'for monthly reminders' do
      context 'for after completion todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, :after_completion, text: 'recurring monthly after completion' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for relative weekdays' do
          it 'returns correct date for weekday and week arrays of length [1, 1]' do
            recurring_todo.recurring_interval_days = [1]
            recurring_todo.recurring_interval_weeks = [1]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,1,7))
          end

          it 'returns correct date for arrays of length [1,>1]' do
            recurring_todo.recurring_interval_days = [1]
            recurring_todo.recurring_interval_weeks = [1, 3]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,17))
          end

          it 'returns correct date for arrays of length [>1,1]' do
            recurring_todo.recurring_interval_days = [1, 3]
            recurring_todo.recurring_interval_weeks = [1]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,1,7))

            recurring_todo.recurring_interval_days = [1, 5]
            recurring_todo.recurring_interval_weeks = [2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,14))
          end

          it 'returns correct date for arrays of length [>1,>1]' do
            recurring_todo.recurring_interval_days = [6, 7]
            recurring_todo.recurring_interval_weeks = [1, 4]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,22))
          end
        end

        context 'for absolute dates' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_days = [15]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,15))

            recurring_todo.recurring_interval_days = [3]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,1,3))

            recurring_todo.recurring_interval_days = [5]
            recurring_todo.recurring_interval_unit_number = 2
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,2,5))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_days = [1, 20]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,20))
          end
        end
      end

      context 'for on schedule todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :monthly, :on_schedule, text: 'recurring monthly on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for relative weekdays' do
          it 'returns correct date when Xth X does not exist' do
            recurring_todo.recurring_interval_days = [1, 3]
            recurring_todo.recurring_interval_weeks = [5]
            recurring_todo.save

            todo.due_date = Date.new(2017,11,7)
            todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017, 12, 31))
          end

          it 'returns correct date for weekday and week arrays of length [1, 1]' do
            recurring_todo.recurring_interval_days = [1]
            recurring_todo.recurring_interval_weeks = [1]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,3))
          end

          it 'returns correct date for arrays of length [1,>1]' do
            recurring_todo.recurring_interval_days = [1]
            recurring_todo.recurring_interval_weeks = [1, 3]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,19))
          end

          it 'returns correct date for arrays of length [>1,1]' do
            recurring_todo.recurring_interval_days = [1, 3]
            recurring_todo.recurring_interval_weeks = [1]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,3))

            recurring_todo.recurring_interval_days = [1, 5]
            recurring_todo.recurring_interval_weeks = [2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,10))
          end

          it 'returns correct date for arrays of length [>1,>1]' do
            recurring_todo.recurring_interval_days = [6, 7]
            recurring_todo.recurring_interval_weeks = [1, 4]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,24))
          end
        end

        context 'for absolute dates' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_days = [15]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,15))

            recurring_todo.recurring_interval_days = [3]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,3))

            recurring_todo.recurring_interval_days = [5]
            recurring_todo.recurring_interval_unit_number = 2
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,1,5))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_days = [1, 20]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,20))
          end
        end
      end
    end

    context 'for weekly reminders' do
      context 'for after completion todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :weekly, :after_completion, text: 'recurring daily after completion' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for unit number == 1' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_days = [1]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,17))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_days = [1, 6]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,15))
          end
        end

        context 'for unit number > 1' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.recurring_interval_days = [2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2018,1,1))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.recurring_interval_days = [2, 5]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,14))
          end
        end
      end

      context 'for on schedule todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :weekly, :on_schedule, text: 'recurring daily on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for unit number == 1' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_days = [2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,20))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_days = [2, 5]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,16))
          end
        end

        context 'for unit number > 1' do
          it 'returns correct date for an array of length 1' do
            recurring_todo.recurring_interval_unit_number = 2
            recurring_todo.recurring_interval_days = [2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,27))
          end

          it 'returns correct date for an array of length > 1' do
            recurring_todo.recurring_interval_unit_number = 2
            recurring_todo.recurring_interval_days = [2, 5]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,16))

            recurring_todo.recurring_interval_unit_number = 2
            recurring_todo.recurring_interval_days = [1, 2]
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,26))
          end
        end
      end
    end

    context 'for daily reminders' do
      context 'for after completion todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :daily, :after_completion, text: 'recurring daily after completion' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for unit number == 1' do
          it 'returns correct date' do
            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,14))
          end
        end

        context 'for unit number > 1' do
          it 'returns correct date' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,12,16))
          end
        end
      end

      context 'for on schedule todos' do
        let!(:recurring_todo) { FactoryGirl.create :recurring_todo, :daily, :on_schedule, text: 'recurring daily on schedule' }
        let!(:todo) { FactoryGirl.create :todo, due_date: Date.new(2017,11,13), complete_date: Date.new(2017,12,13), recurring_todo: recurring_todo }

        context 'for unit number == 1' do
          it 'returns correct date' do
            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,14))
          end
        end

        context 'for unit number > 1' do
          it 'returns correct date' do
            recurring_todo.recurring_interval_unit_number = 3
            recurring_todo.save

            expect(helper.next_recurring_todo_date(todo)).to eq(Date.new(2017,11,16))
          end
        end
      end
    end
  end
