module ApplicationHelper

  # Handles formatting of the page title by appending site name to end
  # of a particular page's title.
  # @param page_title [String] the page title from a particular view.
  def title(page_title)
    default = "Ohana Web Search"
    if page_title.present?
      content_for :title, "#{page_title.to_str} | #{default}"
    else
      content_for :title, default
    end
  end

  # Since this app includes various parameters in the URL when linking to a
  # location's details page, we can end up with many URLs that display the
  # same content. To gain more control over which URL appears in Google search
  # results, we can use the <link> element with the "rel=canonical" attribute.

  # This helper allows us to set the canonical URL for the details page in the
  # view. See app/views/organizations/show.html.haml
  #
  # More info: https://support.google.com/webmasters/answer/139066
  def canonical(url)
    content_for(:canonical, tag(:link, :rel => :canonical, :href => url)) if url
  end

  # Top level services and their children categories.
  # Displayed on the home page.
  # @return [Array] Array of hashes with parent and children describing titles and list items.
  def service_terms
    terms = YAML.load(File.read(File.expand_path("#{Rails.root}/config/#{ Rails.env.test? ? 'test/' : '' }homepage_links.yml", __FILE__)))
    terms['general']
  end

  # Top level services and their children categories.
  # Displayed on the home page.
  # @return [Array] Array of hashes with parent and children describing titles and list items.
  def emergency_terms
    terms = YAML.load(File.read(File.expand_path("#{Rails.root}/config/#{ Rails.env.test? ? 'test/' : '' }homepage_links.yml", __FILE__)))
    terms['priority']
  end

  # @return [Hash] Defines which query terms will display an info box
  # on the results page for select keywords.
  def info_box_terms
    YAML.load(File.read(File.expand_path("#{Rails.root}/config/#{ Rails.env.test? ? 'test/' : '' }terminology.yml", __FILE__)))
  end

  # @return [Hash] Returns a hash that should be fed into a `render` command
  # that will corresponds to the info box partial in /app/views/component/terminology,
  # or nil if no search keyword is present.
  def dynamic_partial
    if params[:keyword].present?
      keyword = params[:keyword].downcase
      # Create 2 arrays: one containing the search terms of the info_box_terms,
      # and the other containing all the synonyms of those terms.
      main_terms = info_box_terms.keys
      synonyms = []
      info_box_terms.select { |k,v| synonyms.push(v['synonyms']) }
      synonyms.flatten!

      # Check if the keyword matches any of the terms or synonyms.
      if (main_terms + synonyms).include?(keyword)

        # If the keyword matches a value, we find the corresponding key.
        # The key is what the partial name corresponds to.
        if synonyms.include?(keyword)
          partial = info_box_terms.find { |k,v| v['synonyms'].include? keyword }.first
        # Otherwise, it means the keyword matches a key
        else
          partial = keyword
        end

        # Grab the specific term details for filling a template partial.
        term = info_box_terms[partial]

        # Replace spaces in the key string with underscores to match
        # the partial name (see app/views/components/terminology),
        # and return the path to the partial for use in the view.
        dynamic_partial = partial.tr(' ','_')

        # Specify the path to the partial.
        partial_path = 'component/terminology'

        # If a partial with the specified name does not exist and the term
        # contains a title, description, and link in the yaml file, use the
        # template partial.
        if !File.exist?("#{Rails.root.join('app','views',partial_path,'_'+dynamic_partial+'.html.haml')}") &&
          info_box_terms[partial].key?('title') &&
          info_box_terms[partial].key?('description') &&
          info_box_terms[partial].key?('url')

          dynamic_partial = 'template'
        end

        {:partial => "#{partial_path}/#{dynamic_partial}", :locals => {:term=>term}}
      end
    end
  end

  # List of Open Eligibility categories for when no search results are found.
  # @return [Array] Arrays of categories and sub-categories.
  # Only returns categories that have been associated with services since
  # it doesn't make sense to include categories that will return no locations.
  def taxonomy_terms
    { "Emergency" =>
        ["Disaster Response", "Emergency Cash", "Cash for Food",
          "Cash for Healthcare", "Cash for Housing", "Cash for Gas",
          "Cash for Utilities", "Emergency Food", "Emergency Shelter",
          "Help Find Missing Persons", "Immediate Safety",
          "Help Escape Violence", "Safe Housing",
          "Psychiatric Emergency Services"
        ],
      "Food" =>
        ["Emergency Food", "Food Delivery", "Food Pantry", "Free Meals",
          "Help Pay for Food", "Food Benefits", "Nutrition"
        ],
      "Housing" =>
        ["Emergency Shelter", "Help Find Housing", "Help Pay for Housing",
          "Cash for Housing", "Cash for Utilities", "Housing Vouchers",
          "Maintenance & Repairs", "Housing Advice", "Foreclosure Counseling",
          "Homebuyer Education", "Residential Housing", "Housing with Support",
          "Long-Term Housing", "Assisted Living", "Independent Living",
          "Nursing Home", "Safe Housing", "Short-Term Housing"
        ],
      "Goods" =>
        ["Baby Supplies", "Baby Clothes", "Clothing", "Baby Clothes",
          "Clothes for School", "Clothes for Work", "Clothing Vouchers",
          "Home Goods", "Blankets & Fans", "Furniture", "Personal Care Items",
          "Technology", "Assistive Technology", "Internet", "Phone Services",
          "Toys & Gifts"
        ],
      "Transit" =>
        ["Help Pay for Transit", "Bus Passes", "Cash for Gas",
          "Transportation", "Transportation for Healthcare",
          "Transportation for School"
        ],
      "Health" =>
        ["Addiction & Recovery", "12-Step", "Detox", "Halfway Housing",
          "Outpatient Treatment", "Residential Treatment", "Sober Living",
          "Dental Care", "End-of-Life Care", "Bereavement", "Hospice",
          "Pain Management", "Health Education", "Daily Life Skills",
          "Disease Management", "Family Planning", "Nutrition",
          "Parenting Education", "Sex Education", "Understand Disability",
          "Understand Mental Health", "Help Pay for Healthcare",
          "Cash for Healthcare", "Discounted Healthcare", "Health Insurance",
          "Medical Supplies", "Prescription Assistance",
          "Transportation for Healthcare", "Medical Care",
          "Alternative Medicine", "Assistive Technology", "Birth Control",
          "Checkup & Test", "Disability Screening", "Disease Screening",
          "Hearing Tests", "Mental Health Evaluation", "Pregnancy Tests",
          "Vision Tests", "Maternity Care", "Personal Hygiene",
          "Prevent & Treat", "Counseling", "HIV Treatment", "Nursing Home",
          "Specialized Therapy", "Vaccinations", "Outpatient Treatment",
          "Psychiatric Emergency Services"
        ],
      "Money" =>
        ["Emergency Cash", "Financial Assistance", "Help Pay for Childcare",
          "Help Pay for Food", "Help Pay for Housing", "Help Pay for Transit",
          "Help Pay for Work Expenses", "Government Benefits",
          "Disability Benefits", "Food Benefits", "Retirement Benefits",
          "Understand Government Programs", "Vouchers", "Clothing Vouchers",
          "Housing Vouchers", "Financial Education", "Foreclosure Counseling",
          "Savings Program", "Insurance", "Health Insurance",
          "Home & Renters Insurance", "Tax Preparation"
        ],
      "Care" =>
        ["Adoption & Foster Care", "Adoption & Foster Placement",
          "Adoption & Foster Parenting", "Adoption Planning",
          "Post-Adoption Support", "Animal Welfare", "Daytime Care",
          "Adult Daycare", "Afterschool Care", "Childcare", "Child Daycare",
          "Day Camp", "Preschool", "Recreation", "Relief for Caregivers",
          "End-of-Life Care", "Bereavement", "Hospice", "Pain Management",
          "Navigating the System", "Help Fill out Forms", "Help Find Housing",
          "Help Find Work", "Residential Care", "Assisted Living",
          "Residential Treatment", "Nursing Home", "Support Network",
          "Counseling", "Help Hotlines", "Home Visiting", "In-Home Support",
          "Mentoring", "One-on-One Support", "Peer Support",
          "Spiritual Support", "Support Groups", "12-Step",
          "Parenting Education", "Virtual Support"
        ],
      "Education" =>
        ["Help Find School", "Help Pay for School", "Books",
          "Financial Aid & Loans", "More Education", "Alternative Education",
          "English as a Second Language (ESL)", "Financial Education",
          "Foreign Languages", "GED/High-School Equivalency",
          "Health Education", "Supported Employment", "Special Education",
          "Tutoring", "Preschool", "Screening & Exams", "GED/High-School",
          "English as a Second Language (ESL)", "Skills & Training",
          "Basic Literacy", "Computer Class", "Daily Life Skills",
          "Interview Training", "Resume Development", "Skills Assessment",
          "Specialized Training", "Technology", "Assistive Technology"
        ],
      "Work" => ["Help Find Work", "Job Placement", "Supported Employment",
        "Help Pay for Work Expenses", "Skills & Training", "Basic Literacy",
        "Computer Class", "GED/High-School Equivalency", "Interview Training",
        "Resume Development", "Skills Assessment", "Specialized Training",
        "Supported Employment", "Workplace Rights"
      ],
      "Legal" =>
        ["Advocacy & Legal Aid", "Adoption & Foster Care",
          "Adoption & Foster Placement", "Adoption Planning",
          "Post-Adoption Support", "Citizenship & Immigration",
          "Discrimination & Civil Rights", "Guardianship",
          "Understand Government Programs", "Workplace Rights", "Mediation",
          "Representation", "Translation & Interpretation"
        ]
    }
  end

end
